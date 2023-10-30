module "aws_infra" {
  source = "../getting-started"
  build_user_name = "sdputurn"
  ssh_key_username = "sdputurn"
}
locals {
  dns = module.aws_infra.dns
}
output "dns" {
  value = local.dns
}