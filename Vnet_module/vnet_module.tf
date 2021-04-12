# Create Vitural Network
resource "azurerm_virtual_network" "vnet" {
  name                = var.vnet_prefix
  address_space       = [var.vnet_address]
  location            = var.vnet_location
  resource_group_name = var.vnet_resource_group_name
  tags = {
    Name = var.tag_vnet_prefix
  }
}

output "name" {
  value = azurerm_virtual_network.vnet.name
}

output "Vnet_CIDR" {
  value = azurerm_virtual_network.vnet.address_space
}
