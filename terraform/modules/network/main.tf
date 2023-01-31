# Create network
resource "azurerm_virtual_network" "my_terraform_network" {
  name                = "${local.environment}-network"
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  tags = local.common_tags
}

# Create the subnet
resource "azurerm_subnet" "my_terraform_network_subnet" {
  name                 = "${local.environment}-subnet"
  resource_group_name  = data.azurerm_resource_group.current.name
  virtual_network_name = azurerm_virtual_network.my_terraform_network.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints = [ "Microsoft.Storage" ]
}

# # Create public IP
# resource "azurerm_public_ip" "my_terraform_public_ip" {
#   name                = "${local.environment}-publicIP"
#   location            = data.azurerm_resource_group.current.location
#   resource_group_name = data.azurerm_resource_group.current.name
#   allocation_method   = "Static"
#   sku = "Standard"
#   tags = local.common_tags
# }

# # Create a SecurityGroup
# resource "azurerm_network_security_group" "my_terraform_nsg" {
#   name                = "${local.environment}-nsg"
#   location            = data.azurerm_resource_group.current.location
#   resource_group_name = data.azurerm_resource_group.current.name

#   security_rule {
#     name                       = "SSH"
#     priority                   = 1001
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "22"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "HTTP"
#     priority                   = 1002
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "80"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   security_rule {
#     name                       = "HTTPS"
#     priority                   = 1003
#     direction                  = "Inbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "*"
#   }

#   tags = local.common_tags
# }

# # Create NIC
# resource "azurerm_network_interface" "my_terraform_nic" {
#   name                = "${local.environment}-nic"
#   location            = data.azurerm_resource_group.current.location
#   resource_group_name = data.azurerm_resource_group.current.name

#   ip_configuration {
#     name                          = "${local.environment}-nicConfiguration"
#     subnet_id                     = azurerm_subnet.my_terraform_network_subnet.id
#     private_ip_address_allocation = "Dynamic"
#     # public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
#   }

#   tags = local.common_tags
# }

# # Get the connect between NIC and security group
# resource "azurerm_network_interface_security_group_association" "my_terraform_asNicSG" {
#   network_interface_id      = azurerm_network_interface.my_terraform_nic.id
#   network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
# }

# Create the nat_gateway and load_blancer
# resource "azurerm_nat_gateway" "main" {
#   name = "${local.environment}-NATGateway"
#   location = data.azurerm_resource_group.current.location
#   resource_group_name = data.azurerm_resource_group.current.name
#   sku_name = "Standard"
# }

# resource "azurerm_nat_gateway_public_ip_association" "main" {
#   nat_gateway_id = azurerm_nat_gateway.main.id
#   public_ip_address_id = azurerm_public_ip.my_terraform_public_ip.id
# }

# resource "azurerm_subnet_nat_gateway_association" "main" {
#   subnet_id = azurerm_subnet.my_terraform_network_subnet.id
#   nat_gateway_id = azurerm_nat_gateway.main.id
# }

resource "azurerm_public_ip" "publicip_LB" {
  name = "${local.environment}-lbpublicIP"
  resource_group_name = data.azurerm_resource_group.current.name
  location = data.azurerm_resource_group.current.location
  allocation_method = "Static"
  sku = "Standard"
  tags = local.common_tags
}

resource "azurerm_application_security_group" "main" {
  name = "${local.environment}-asg"
  location = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  tags = local.common_tags
}

# Create a load balancer
resource "azurerm_lb" "main" {
  name = "${local.environment}-LoadBalancer"
  location = data.azurerm_resource_group.current.location
  resource_group_name = data.azurerm_resource_group.current.name
  sku = "Standard"

  frontend_ip_configuration {
    name = "${local.environment}-publicIPlbConfiguration"
    public_ip_address_id = azurerm_public_ip.publicip_LB.id
  }
}

resource "azurerm_lb_backend_address_pool" "main" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-backendlbConfiguration"
}

resource "azurerm_lb_probe" "healthcheckHTTP" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-probeHTTP"
  port = "80"
}

resource "azurerm_lb_probe" "healthcheckHTTPS" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-probeHTTPS"
  port = "443"
}

resource "azurerm_lb_rule" "ruleHTTP" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-LBruleHTTP"
  protocol = "Tcp"
  frontend_port = 80
  backend_port = 80
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.main.id ]
  frontend_ip_configuration_name = "${local.environment}-publicIPlbConfiguration"
  probe_id = azurerm_lb_probe.healthcheckHTTP.id
  disable_outbound_snat = true
}

resource "azurerm_lb_rule" "ruleHTTPS" {
  loadbalancer_id = azurerm_lb.main.id
  name = "${local.environment}-LBruleHTTPS"
  protocol = "Tcp"
  frontend_port = 443
  backend_port = 443
  backend_address_pool_ids = [ azurerm_lb_backend_address_pool.main.id ]
  frontend_ip_configuration_name = "${local.environment}-publicIPlbConfiguration"
  probe_id = azurerm_lb_probe.healthcheckHTTPS.id
  disable_outbound_snat = true
}

resource "azurerm_lb_outbound_rule" "name" {
  name = "${local.environment}-LBOutboundRule"
  loadbalancer_id = azurerm_lb.main.id
  protocol = "Tcp"
  backend_address_pool_id = azurerm_lb_backend_address_pool.main.id

  frontend_ip_configuration {
      name = "${local.environment}-publicIPlbConfiguration"
  }
}

# # Assign address can connect into from subnet
# resource "azurerm_lb_backend_address_pool_address" "name" {
#   backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
#   name = "${local.environment}-backendlbConfigurationAddress"
#   virtual_network_id = azurerm_virtual_network.my_terraform_network.id
#   ip_address = azurerm_network_interface.my_terraform_nic.private_ip_address
# }

# resource "azurerm_lb_nat_rule" "https_rule" {
#   resource_group_name = data.azurerm_resource_group.current.name
#   loadbalancer_id = azurerm_lb.main.id
#   name = "HTTPS_Access"
#   protocol = "Tcp"
#   frontend_port_start = "443"
#   frontend_port_end = "443"
#   backend_port = "443"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
#   frontend_ip_configuration_name = "${local.environment}-publicIPlbConfiguration"
# }

# resource "azurerm_lb_nat_rule" "ssh_rule" {
#   resource_group_name = data.azurerm_resource_group.current.name
#   loadbalancer_id = azurerm_lb.main.id
#   name = "SSH_Access"
#   protocol = "Tcp"
#   frontend_port_start = "22"
#   frontend_port_end = "22"
#   backend_port = "22"
#   backend_address_pool_id = azurerm_lb_backend_address_pool.main.id
#   frontend_ip_configuration_name = "${local.environment}-publicIPlbConfiguration"
# }