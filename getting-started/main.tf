# first terraform code. this is main file containing all the different 
# blocks (resources, variables, outputs, providers, terraform, data sources, locals)

# terraform: (some people refer this as versions)
terraform {
  required_version = ">= 1.0"

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0, < 5.20.0"
    }
  }
}
# provider: (we define prvider configuration here if it supports any like aws
# required region and access keys. some provider does not need 
# any configuration like random)

provider "aws" {
  region = "us-east-1"
}
# variables: precidence env var TF_VAR_, default terraform.tfvars, .auto.tfvars, --var-file, --var, command line prompt
# syntax var "name_label" {}

variable "name" {
  type        = string
  description = "Build user name"
  sensitive   = false
}

# data: syntax data "data_source_label" "name_label" {"provider_data_arguments"}
data "aws_ssm_parameter" "amzn2_linux" {
  name = "/aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2"
}

# resource: syntax resource "resource_label" "name_label" {"resource arguments"}

# NETWORKING #
resource "aws_vpc" "app" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true

}

resource "aws_internet_gateway" "app" {
  vpc_id = aws_vpc.app.id

}

resource "aws_subnet" "public_subnet1" {
  cidr_block              = "10.0.0.0/24"
  vpc_id                  = aws_vpc.app.id
  map_public_ip_on_launch = true
}

# ROUTING #
resource "aws_route_table" "app" {
  vpc_id = aws_vpc.app.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.app.id
  }
}

resource "aws_route_table_association" "app_subnet1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.app.id
}

# SECURITY GROUPS #
# Nginx security group 
resource "aws_security_group" "nginx_sg" {
  name   = "nginx_sg"
  vpc_id = aws_vpc.app.id

  # HTTP access from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  tags = {
    "user" = var.name
  }

  user_data = <<EOF
#! /bin/bash
sudo amazon-linux-extras install -y nginx1
sudo service nginx start
sudo rm /usr/share/nginx/html/index.html
echo '<html><head><title>Taco Team Server</title></head><body style=\"background-color:#1F778D\"><p style=\"text-align: center;\"><span style=\"color:#FFFFFF;\"><span style=\"font-size:28px;\">You did it! Have a &#127790;</span></span></p></body></html>' | sudo tee /usr/share/nginx/html/index.html
EOF

}
# locals: syntax locals { key = value } //kind of a scratch pad

# output: syntax output "name_label" {"value" = "value to output" , "sensitive" = 
# true|false if value is just need to passed to another module and no need to print to output}

output "dns" {
  value = aws_instance.nginx1.public_dns
  description = "web server public address"
}
