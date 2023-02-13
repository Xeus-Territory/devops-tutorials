variable "resource_group_name" {
  type = string
  description = "Resource group name of Dev Environment"
}

variable "resource_group_location" {
  type = string
  description = "Resource group location of Dev Environment"
}

variable "environment" {
  type = string 
  description = "Enviroment name for working"
}

variable "tags" {
  type = map
  description = "Resource tags"
    default = null
}
