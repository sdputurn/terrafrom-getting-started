module "aws_infra" {
  source = "../getting-started"
  build_user_name = "sdputurn"
  ssh_key_username = "sdputurn"
}

output "dns" {
  value = module.aws_infra.dns
}