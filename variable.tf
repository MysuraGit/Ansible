variable "Dev-vpc" {
    description = "Create vpc"
    type = string 
    default = "10.0.0.0/16"
  
}
variable "public-subnet-1" {
    description = "Create public subnet" # create public subnet
    type = string 
    default = "10.0.1.0/24"
  
}

variable "privat-subnet-1" {
    description = "Create private subnet" # create private subnet
    type = string 
    default = "10.0.2.0/24"
  
}