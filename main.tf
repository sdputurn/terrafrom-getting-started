variable "token" {
    # default = var.token
  
}
provider "github" {
    token = var.token
  
}
module "github_repository" {
    source = "./modules"
    
    
  
}