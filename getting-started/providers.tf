# provider: (we define prvider configuration here if it supports any like aws
# required region and access keys. some provider does not need 
# any configuration like random)

provider "aws" {
  region = "us-east-1"
}