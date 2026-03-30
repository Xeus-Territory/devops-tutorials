# Create the virtual machine
resource "azurerm_linux_virtual_machine" "main" {
  name                  = "${var.os}-AgentVM"
  computer_name         = var.vmname
  resource_group_name   = var.resource_group_name
  location              = var.location
  size                  = var.sizedisk
  admin_username        = var.admin_username
  network_interface_ids = [var.nic_id]
  os_disk {
    name                 = "${var.os}-diskAgentVM"
    caching              = var.caching
    storage_account_type = var.storage_account_type
  }

  admin_ssh_key {
    username   = var.admin_name_for_ssh
    public_key = var.public_key
  }

  source_image_reference {
    publisher = var.configuration_vm.publisher
    offer     = var.configuration_vm.offer
    sku       = var.configuration_vm.sku
    version   = var.configuration_vm.version
  }

  disable_password_authentication = true

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_identity_id]
  }

  user_data = base64encode(
    templatefile(
      "${abspath(path.module)}/data/userdata.sh",
      {
        user    = var.admin_username,
        url     = var.url_org,
        auth    = var.auth_type,
        token   = var.token,
        pool    = var.pool,
        agent   = var.agent,
        workdir = var.workdir
      }
    )
  )

  tags = var.tag
}
