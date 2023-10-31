variable "token" {
  # default = var.token

}
provider "github" {
  token = var.token

}

variable "username" {}

module "github_repository" {
  username = var.username
  source   = "./modules"
}



output "main" {
  value = "${var.username} +++++++++++++ ${var.token} ++++++++ ${module.github_repository.going_crazy}"
}