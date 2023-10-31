output "az" {
  value = [ for i,j in var.object_example: var.object_example[i] ]
}