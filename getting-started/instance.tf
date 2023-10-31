# resource: syntax resource "resource_label" "name_label" {"resource arguments"}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEA1O151veNnsb1RYAleGrquc6htCBy7xPOKB4jK7YtFOyrhwJk9KBGQVwzopjIM2ICpG8iydtZefdiLIR767q5/JMDJE91b9TvJ6KXqJGm1rVFmv+Q0aN6LCK5gXhbZpQFaxvaNNNIT+F+j77K9EIoUumeQWXRSi2H0rOeUL0LK4TlQUoN2RhnIl7/2twjDF8WqAAdB79sztDSxxsQL0/NB4UzAJ4aqSj5IQ+99GjiuhiuCONjMIz+1atYvP1bYd/dBjyCmBuZU77kLF3oiJ4gnwsIexoeZJ+V3nl8TW71KWzze3RQmkuik86MYosmHEbHoivjlkM/D2Yu9B6TVAiuww=="
}
# INSTANCES #
resource "aws_instance" "nginx1" {
  count = 2
  ami                    = nonsensitive(data.aws_ssm_parameter.amzn2_linux.value)
  instance_type          = var.instance_type
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