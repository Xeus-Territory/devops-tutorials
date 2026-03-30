# Move the azure for new resource
resource "azurerm_resource_group" "main" {
  name = var.resource_group_name
  location = var.location
  tags = var.tag
}
module "iam" {
    source = "../modules/iam"
    os = var.os
    resource_group_name = var.resource_group_name
    resource_group_id = azurerm_resource_group.main.id
    location = var.location
    subscription_target = data.azurerm_subscription.main.id
    depends_on = [
      azurerm_resource_group.main
    ]
}

module "network" {
    source = "../modules/network"
    os = var.os
    resource_group_name = var.resource_group_name
    address_prefixes_subnet = [ "10.0.4.0/24" ]
    service_endpoints = [ "Microsoft.Storage" ]
    tag = var.tag
    depends_on = [
      module.iam
    ]
}

module "vm" {
    source = "../modules/vm"
    os = var.os
    resource_group_name = var.resource_group_name
    nic_id = module.network.nic_id
    user_identity_id = module.iam.user_identity_id
    public_key = data.azurerm_ssh_public_key.main.public_key
    tag = var.tag
    url_org = var.url_org
    token = var.token
    pool = var.pool
    agent = var.agent
    depends_on = [
      module.network,
      module.iam
    ]
}