terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-southeast-1"
    access_key = "AKIA36JF4F2OD6TJKAED" 
    secret_key = "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" 
}


resource "aws_vpc" "main" {
  cidr_block = "10.20.0.0/16"
  tags = {
    Name = "aetherlock-vpc"
  }
}

resource "aws_subnet" "public" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.${count.index + 1}.0/24" 
  availability_zone = "ap-southeast-1${element(["a", "b"], count.index)}" 
  map_public_ip_on_launch = true
  tags = {
    Name = "aeteherlock-public-subnet-${count.index + 1}"
  }
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.20.10${count.index + 1}.0/24"
  availability_zone = "ap-southeast-1${element(["a", "b"], count.index)}"
  tags = {
    Name = "aetherlock-private-subnet-${count.index + 1}"
  }
}


resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "aetherlock-igw"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "aetherlock-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"
}

resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "aetherlock-nat-gw"
  }
  depends_on = [aws_internet_gateway.main_igw]
}

resource "aws_route_table" "private_rt {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.main_nat.id
  }
  tags = {
    Name = "aetherlock-private-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  count          = length(aws_subnet.public)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private_rt.id
}


resource "aws_security_group" "web_sg" {
  name        = "aetherlock-sg"
  description = "Allow HTTP, HTTPS, and SSH access"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Allow SSH from anywhere (for try)"
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

resource "aws_instance" "aetherlock_server" {
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
              echo "<h1>UJK BNSP <alvi></h1>" | sudo tee /var/www/html/index.html
              EOF
              
  tags = {
    Name = ""
  }
}


