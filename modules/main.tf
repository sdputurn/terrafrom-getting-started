variable "repo_name" {
    default = "terrafrom-module-getting-started"
  
}
variable "description" {
    default = "terrafrom module basics"
  
}
resource "github_repository" "learnings" {
    name = var.repo_name
    description = var.description
    auto_init = true
    visibility = "public"  
}