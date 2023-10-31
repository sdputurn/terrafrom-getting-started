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
  availability_zone = data.aws_availability_zones.available.names[0]
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public_subnet2" {
  cidr_block              = "10.0.1.0/24"
  vpc_id                  = aws_vpc.app.id
  availability_zone = data.aws_availability_zones.available.names[1]
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