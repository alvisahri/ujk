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
    access_key = "" 
    secret_key = "" 
}


resource "" "" {
  cidr_block = ""
  tags = {
    Name = ""
  }
}

resource "" "" {
  count             = 
  vpc_id            = 
  cidr_block        = "" 
  availability_zone = "" 
  map_public_ip_on_launch = 
  tags = {
    Name = ""
  }
}

resource "" "" {
  count             = 
  vpc_id            = 
  cidr_block        = "" 
  availability_zone = ""
  tags = {
    Name = ""
  }
}


resource "" "" {
  vpc_id = 
  tags = {
    Name = ""
  }
}

resource "" "" {
  vpc_id = 
  route {
    cidr_block = ""
    gateway_id = 
  }
  tags = {
    Name = ""
  }
}

resource "" "" {
  count          = 
  subnet_id      = 
  route_table_id = 
}

resource "" "" {
  name        = ""
  description = ""
  vpc_id      = 

  ingress {
    description = ""
    from_port   = 
    to_port     = 
    protocol    = ""
    cidr_blocks = [""]
  }
  ingress {
    description = ""
    from_port   = 
    to_port     = 
    protocol    = ""
    cidr_blocks = [""]
  }
  ingress {
    description = ""
    from_port   = 
    to_port     = 
    protocol    = ""
    cidr_blocks = [""]
  }

  egress {
    from_port   = 
    to_port     = 
    protocol    = "" 
    cidr_blocks = [""]
  }
}

resource "aws_instance" "" {
  ami           = "ami-0b8607d2721c94a77"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public[0].id
  security_groups = [aws_security_group.web_sg.id]
  key_name        = ""

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>UJK BNSP <nama kalian></h1>" | sudo tee /var/www/html/index.html
              EOF
              
  tags = {
    Name = ""
  }
}


