##################### premitive type # string number boolean
variable "build_user" {
  type = string
  default = "sandeep"
}
variable "vm_count" {
  type = number
  default = 2
}
variable "build_flag" {
  type = bool
  default = true
}
################# collection # map list set

variable "region" {
  type = list(string) #list is collection of same data type
  default = ["us-east","us-west","us-central"]
}
variable "flavour" {
  type = map(string)
  default = {
    "small" = "t2"
    "medium" = "c2"
    "large" = "m2"
  }
}
variable "az" {
  type = set(string) # set is unordered list and does have duplicates. order is not guranted
  # Elements of a set are identified only by their value and don't have any separate index or key to select with, 
  # so it's only possible to perform operations across all elements of the set.
  default = [ "3","1","2" ]
}
##################### structural # tuple object

################## any

################## Null