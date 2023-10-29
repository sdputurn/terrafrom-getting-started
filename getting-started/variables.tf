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

variable "instance_type" {
  type = string
  default = "t2.micro"
}

data "aws_availability_zones" "available" {
  state = "available"
}
