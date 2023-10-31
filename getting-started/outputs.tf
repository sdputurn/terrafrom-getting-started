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
output "intance_type" {
  value = "instance type = ${var.instance_type}"
}