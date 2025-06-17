terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region     = "ap-southeast-1"
  access_key = ""         
  secret_key = "" 
}

resource "aws_vpc" "main" {
  cidr_block = "10.20.0.0/16"
  tags = {
    Name = "aetherlock2-vpc"
  }
}

resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.20.${count.index + 1}.0/24"
  availability_zone       = "ap-southeast-1${element(["a", "b"], count.index)}"
  map_public_ip_on_launch = true
  tags = {
    Name = "aetherlock2-public-subnet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "aetherlock2-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "aetherlock2-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# Security Group
resource "aws_security_group" "web_sg" {
  name        = "aetherlock2-sg"
  description = "Allow HTTP, HTTPS, and SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "aetherlock2_server" {
  ami           = "ami-0b8607d2721c94a77" 
  instance_type = "t2.micro"             
  subnet_id     = aws_subnet.public[0].id
  security_groups = [aws_security_group.web_sg.id]
  key_name        = "ujk"                 

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>UJK BNSP <nama kalian></h1>" | sudo tee /var/www/html/index.html
              EOF

  tags = {
    Name = "WebServer-Test"
  }
}
