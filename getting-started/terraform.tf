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