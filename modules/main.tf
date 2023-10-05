variable "repo_name" {
    default = "terrafrom-module-getting-started"
  
}
variable username {}

variable "description" {
    default = "terrafrom module basics"
  
}
resource "github_repository" "learnings" {
    name = var.repo_name
    description = format("%s - %s", var.description, var.username )
    auto_init = true
    visibility = "public"  
}
resource "github_repository" "learnings2" {
    name = format("%s-%s", var.repo_name , "two")
    description = var.description 
    auto_init = true
    visibility = "public"  
}

output "going_crazy" {
  value = "${github_repository.learnings.html_url} ++++++++ ${github_repository.learnings2.html_url}" 
  
}