#################
## premitive type # string number boolean
#################
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

################## 
## collection # map list set
##################

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
  type = set(string) # set is unindexed list and does have duplicates.
  # Elements of a set are identified only by their value and don't have any separate index or key to select with, 
  # so it's only possible to perform operations across all elements of the set.
  default = [ "3","1","2" ] #when terraform initialize this will be sorted
}


##############
## structural # tuple object
##############


variable "tuple_example" {
  type = tuple([string, number, bool])
  default = ["aws", 1, true]
}

variable "object_example" {
  type = object({
    name = string
    id = number
    active = bool
    likes = list(string)
  })
  default = {
    active = true
    name = "aws"
    id = 123
    likes = ["tea", "coffe"]
  }
}

################ 
## any
################

variable "any_example" {
  type = any
  default = 123
}

################## Null

variable "null_example" {
  type = number
  default = null
  
}