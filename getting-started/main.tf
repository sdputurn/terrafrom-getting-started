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
      version = ">= 5.0.0, <= 5.20.0"
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

variable "build_user_name" {
  type        = string
  description = "Build user name"
  sensitive   = false
}
variable "ssh_key_username" {}
# data: syntax data "data_source_label" "name_label" {"provider_data_arguments"}
data "aws_ssm_parameter" "amzn2_linux" {
  name = "ami-id"
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
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
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
# ssh keys
# resource "aws_iam_user" "user" {
#   name = "test-user"
#   path = "/"
# }

# resource "aws_iam_user_ssh_key" "iam_user" {
#   username   = var.ssh_key_username
#   encoding   = "SSH"
#   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1O151veNnsb1RYAleGrquc6htCBy7xPOKB4jK7YtFOyrhwJk9KBGQVwzopjIM2ICpG8iydtZefdiLIR767q5/JMDJE91b9TvJ6KXqJGm1rVFmv+Q0aN6LCK5gXhbZpQFaxvaNNNIT+F+j77K9EIoUumeQWXRSi2H0rOeUL0LK4TlQUoN2RhnIl7/2twjDF8WqAAdB79sztDSxxsQL0/NB4UzAJ4aqSj5IQ+99GjiuhiuCONjMIz+1atYvP1bYd/dBjyCmBuZU77kLF3oiJ4gnwsIexoeZJ+V3nl8TW71KWzze3RQmkuik86MYosmHEbHoivjlkM/D2Yu9B6TVAiuww=="
# }
resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1O151veNnsb1RYAleGrquc6htCBy7xPOKB4jK7YtFOyrhwJk9KBGQVwzopjIM2ICpG8iydtZefdiLIR767q5/JMDJE91b9TvJ6KXqJGm1rVFmv+Q0aN6LCK5gXhbZpQFaxvaNNNIT+F+j77K9EIoUumeQWXRSi2H0rOeUL0LK4TlQUoN2RhnIl7/2twjDF8WqAAdB79sztDSxxsQL0/NB4UzAJ4aqSj5IQ+99GjiuhiuCONjMIz+1atYvP1bYd/dBjyCmBuZU77kLF3oiJ4gnwsIexoeZJ+V3nl8TW71KWzze3RQmkuik86MYosmHEbHoivjlkM/D2Yu9B6TVAiuww=="
}
# INSTANCES #
resource "aws_instance" "nginx1" {
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public_subnet1.id
  vpc_security_group_ids = [aws_security_group.nginx_sg.id]
  tags = {
    "user" = var.build_user_name
  }
  key_name = aws_key_pair.deployer.key_name

  user_data = <<EOF
#! /bin/bash
sudo yum install -y nginx
sudo systemctl start nginx
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
output "ami-name" {
  value = nonsensitive("${data.aws_ssm_parameter.amzn2_linux.value}") #- ${ data.aws_ssm_parameter.amzn2_linux.value }"
  sensitive = false
}