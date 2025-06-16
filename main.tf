terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
  }
}

provider "aws" {
  region = "ap-southeast-1" #jangan diganti
  access_key = ""
  secret_key = ""
}

resource "" "" {
  cidr_block = ""
  tags = {
    Name = ""
  }
}

resource "" {
  count                   = 
  vpc_id                  = 
  cidr_block              = 
  availability_zone       = 
  map_public_ip_on_launch = 
  tags = {
    Name = ""
  }
}

resource "" {
  count             = 
  vpc_id            = 
  cidr_block        = ""
  availability_zone = ""
  tags = {
    Name = ""
  }
}

resource "" {
  vpc_id = 
  tags = {
    Name = ""
  }
}

resource "" {
  vpc_id = 
  route {
    cidr_block = ""
    gateway_id = 
  }
  tags = {
    Name = ""
  }
}

resource "" {
  count          = 
  subnet_id      = 
  route_table_id = 
}

resource "" {
  domain = ""
}

resource "" "" {
  allocation_id = 
  subnet_id     = 
  tags = {
    Name = ""
  }
  depends_on = []
}

resource "" "" {
  vpc_id = 
  route {
    cidr_block     = ""
    nat_gateway_id = 
  }
  tags = {
    Name = ""
  }
}

resource "" {
  count          = 
  subnet_id      = 
  route_table_id = 
}

resource "" {
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

resource "" "" {
  ami           = "ami-0b8607d2721c94a77" #jangan diganti
  instance_type = "t2.micro" #jangan diganti
  subnet_id     = 
  security_groups = 
  key_name        = ""

  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y nginx
              sudo systemctl start nginx
              sudo systemctl enable nginx
              echo "<h1>UJK BNSP <ISI NAMA ANDA></h1>" | sudo tee /var/www/html/index.html #HAPUS TANDA <>
              EOF

  tags = {
    Name = ""
  }
}
