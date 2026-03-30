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
}

variable "default_node_pool_name" {
  type = string 
  description = "Method to upgrade  cluster"
  default = "default"
}

variable "node_count" {
  type = number 
  description = "Number of node for default agent pool"
  default = 1
}

variable "vm_size" {
  type = string 
  description = "Size of VM Cluster"
  default = "Standard_B2s"
}

variable "automatic_channel_upgrade" {
  type = string 
  description = "Method to upgrade  cluster"
  default = "stable"
}

variable "kubernetes_version" {
  type = string
  description = "kubernetes version"
  default = "1.29"
}

variable "subnet_node_pools_id" {
  type = string
  description = "Id of subnet using for node pools"
}