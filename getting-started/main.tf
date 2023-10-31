# first terraform code. this is main file containing all the different 
# blocks (resources, variables, outputs, providers, terraform, data sources, locals)

# terraform: (some people refer this as versions)

# provider: (we define prvider configuration here if it supports any like aws
            # required region and access keys. some provider does not need 
            # any configuration like random)

# variables: precidence env var TF_VAR_, default terraform.tfvars, .auto.tfvars, --var-file, --var, command line prompt
             # syntax var "name_label" {}

variable "name" {
  type = string
  description = "Employee name"
  sensitive = false
}

# data: syntax data "data_source_label" "name_label" {"provider_data_arguments"}

# resource: syntax resource "resource_label" "name_label" {"resource arguments"}

# locals: syntax locals { key = value } //kind of a scratch pad

# output: syntax output "name_label" {"value" = "value to output" , "sensitive" = 
          # true|false if value is just need to passed to another module and no need to print to output}

output "name" {
  value = var.name
}
