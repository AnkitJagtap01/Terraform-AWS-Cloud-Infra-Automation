terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# # Configure the AWS Provider
# provider "aws" {
#   region = "us-east-1"
#   access_key = "AKIA6ROVZRI7MCVL3XEJ"
#   secret_key = "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"
# }

# # Create an EC2 instance
# resource "aws_instance" "terraform-instance" {
#   ami           = "ami-08a0d1e16fc3f61ea"
#   instance_type = "t2.micro"
#   subnet_id     = "subnet-04140fe9a556348cc"

#   tags = {
#     Name = "tf-tag-update"
#   }
# }

# # Create a VPC instance
# resource "aws_vpc" "first-vpc" {
#   cidr_block       = "10.0.0.0/16"

#   tags = {
#     Name = "production"
#   }
# }

# resource "aws_subnet" "subnet-1" {
#   vpc_id = aws_vpc.first-vpc.id
#   cidr_block       = "10.0.0.0/24"

#   tags = {
#     Name = "prod-subnet"
#   }
# }

# 1. Create VPC

resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "production"
  }
}

# 2. Create Internet Gateway

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.prod-vpc.id
}

# 3. Create Custom Route Table

resource "aws_route_table" "prod-route-table" {
  vpc_id = aws_vpc.prod-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "Prod"
  }
}

# 4. Create a Subnet

  resource "aws_subnet" "subnet-1" {
    vpc_id = aws_vpc.prod-vpc.id
    cidr_block       = "10.0.1.0/24"
    availability_zone = "us-east-1a"

    tags = {
      Name = "prod-subnet"
    }
  }

# 5. Associate subnet with Route Table

  resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.prod-route-table.id
}

# 6. Create Security Group to allow port 22, 80, 443

resource "aws_security_group" "allow_web" {
  name        = "allow_web_traffic"
  description = "Allow web traffic"
  vpc_id      = aws_vpc.prod-vpc.id

  tags = {
    Name = "allow_web_traffic"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_web_https" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_web_http" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_web_ssh" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv6" {
  security_group_id = aws_security_group.allow_web.id
  cidr_ipv6         = "::/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

# 7. Create a network interface with an ip in the subnet that was created in step 4

resource "aws_network_interface" "web-server-aj" {
  subnet_id       = aws_subnet.subnet-1.id
  private_ips     = ["10.0.1.50"]
  security_groups = [aws_security_group.allow_web.id]
}

# 8. Assign an elastic IP to the network interface created in step 7

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.web-server-aj.id
  associate_with_private_ip = "10.0.1.50"
  depends_on = [ aws_internet_gateway.gw ]
}

output "server_public_ip" {
  value = aws_eip.one.public_ip
}

# 9. Create Ubuntu server and install/enable apache server

resource "aws_instance" "web-server-instance"{
  ami = "ami-04b70fa74e45c3917"
  instance_type = "t2.micro"
  availability_zone = "us-east-1a"
  key_name = "main-key"

  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.web-server-aj.id
  }

  user_data = <<EOF
              #!/bin/bash
              sudo apt update -y
              sudo apt install apache2 -y
              sudo systemctl start apache2
              sudo bash -c 'echo Yes! You cretaed this server through TERRAFORM! > /var/www/html/index.html'
              EOF
  tags = {
    Name = "web-server"
  }
}

output "server_private_ip" {
  value = aws_instance.web-server-instance.private_ip

}

output "server_id" {
  value = aws_instance.web-server-instance.id
}