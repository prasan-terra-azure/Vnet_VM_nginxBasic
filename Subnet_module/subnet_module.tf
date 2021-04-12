############# Subnet #################
resource "azurerm_subnet" "subnet" {
  count                = var.subnet_count
  name                 = var.subnet_name[count.index]
  resource_group_name  = var.rg_name
  virtual_network_name = var.vnet_name
  address_prefixes     = [var.subnet_addr[count.index]]
}

#### output module values ####

output "subnet_CIDR" {
  value = azurerm_subnet.subnet[*].address_prefixes
}

output "subnet_id" {
  //count = 1
  value = azurerm_subnet.subnet[*].id
  //value = element(azurerm_subnet.subnet.id, 0)
}
