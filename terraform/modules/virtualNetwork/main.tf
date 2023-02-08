# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "${var.environment}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  tags = var.tags
}

# Create a Subnet
resource "azurerm_subnet" "main" {
  name                 = "${var.environment}-subnet"
  resource_group_name  = data.azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
}

# Create a Application Security Group for VM Scale Set
resource "azurerm_application_security_group" "main" {
  name                = "${var.environment}-asg-web"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  tags = var.tags
}

# Create a Network Security Group for Subnet
resource "azurerm_network_security_group" "main" {
  name                = "${var.environment}-nsg"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name

  security_rule {
    name                       = "HTTP"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_application_security_group_ids = [ azurerm_application_security_group.main.id ]
  }

  security_rule {
    name                       = "HTTPS"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_application_security_group_ids = [ azurerm_application_security_group.main.id ]
  }

  tags = var.tags
}

# Association Network Security Group(NSG) and Subnet  
resource "azurerm_subnet_network_security_group_association" "main" {
  subnet_id      = azurerm_subnet.main.id
  network_security_group_id = azurerm_network_security_group.main.id
}
