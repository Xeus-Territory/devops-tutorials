variable "resource_group_name" {
    type = string
    description = "Resource group name of module"
}

variable "os" {
    type = string
    description = "os of module"
}

variable "public_key" {
    type = string
    description = "public key of module"
    sensitive = true
}

variable "location" {
    type = string
    description = "location of resource group"
    default = "southeastasia"
}

variable "vmname" {
    type = string
    description = "Name of vm for module"
    default = "ReleaseVM"
}

variable "sizedisk" {
    type = string
    description = "Size of disk vm for module"
    default = "Standard_B1s"
}

variable "admin_username" {
    type = string
    description = "admin username for module"
    default = "intern"
}

variable "caching" {
    type = string
    description = "caching style of disk vm for module"
    default = "ReadWrite"
}

variable "storage_account_type" {
    type = string
    description = "storage account type of disk vm for module"
    default = "StandardSSD_LRS"
}

variable "admin_name_for_ssh" {
    type = string
    description = "admin name for ssh key login for module"
    default = "intern"
    sensitive = true
}

variable "configuration_vm" {
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
    })
    description = "configuration for type of linux VM"
    default = {
      publisher = "Canonical"
      offer = "UbuntuServer"
      sku = "18.04-LTS"
      version = "latest"
    }
}

variable "tag" {
    type = map
    description = "Tag of module"
}

variable "url_org" {
    type = string
    description = "URL of organization where give access for pool"
    sensitive = true
}

variable "auth_type" {
    type = string
    description = "authentication type for pool"
    default = "pat"
}

variable "token" {
    type = string
    description = "token for the identity"
    sensitive = true
}

variable "pool" {
    type = string
    description = "pool which to create for respresentive"
}

variable "agent" {
    type = string
    description = "agent which to create for respresentive"
}

variable "workdir" {
    type = string
    description = "work directory for pool"
    default = "usr/local/agent_work"
}

variable "user_identity_id" {
    type = string
    description = "user identity id for pool"
}

variable "nic_id" {
    type = string
    description = "nic id for pool"
}