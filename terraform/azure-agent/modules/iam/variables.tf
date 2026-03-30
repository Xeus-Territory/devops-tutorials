variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "resource_group_id" {
    type = string
}

variable "os" {
    type = string
    description = "os for module"
}

variable "subscription_target" {
    type = string
    description = "subscription target for the specified"
    sensitive = true
}