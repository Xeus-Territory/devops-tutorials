output "nic_id" {
  value = azurerm_network_interface.main.id
  sensitive = true
}