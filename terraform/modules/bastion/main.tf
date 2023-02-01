resource "azurerm_public_ip" "bastion_public_ip" {
    name = "${local.environment}-bastionPublicIP"
    location = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name
    allocation_method = "Static"
    sku = "Standard"
}

resource "azurerm_subnet" "bastion_subnet" {
    name = "AzureBastionSubnet"
    resource_group_name = data.azurerm_resource_group.main.name
    virtual_network_name = data.azurerm_virtual_network.main.name
    address_prefixes = [ "10.0.2.0/29" ]
}

resource "azurerm_bastion_host" "main" {
    name = "${local.environment}-bastionHost"
    location = data.azurerm_resource_group.main.location
    resource_group_name = data.azurerm_resource_group.main.name

    ip_configuration {
      name = "${local.environment}-bastionConfiguration"
      subnet_id = azurerm_subnet.bastion_subnet.id
      public_ip_address_id = azurerm_public_ip.bastion_public_ip.id
    }
}