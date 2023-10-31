variable "username" {
  default = "sandeep"
}
variable "token" {
#   default = "free"
}
output "tty" {
  value = github_repository.getting-started.html_url


}
provider "github" {
    token = var.token
    # reading from env variable

}
resource "github_repository" "getting-started" {
  name = "terrafrom-getting-started"
  auto_init = true
  description = "learning terraform ${var.username}"
  visibility = "public"
}