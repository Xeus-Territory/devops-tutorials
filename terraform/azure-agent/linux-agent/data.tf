data "azurerm_resource_group" "main" {
    name = "DevOpsIntern"
}

data "azurerm_ssh_public_key" "main" {
    name = "DevOpsIntern"
    resource_group_name = data.azurerm_resource_group.main.name
}

data "azurerm_subscription" "main" {
  
}