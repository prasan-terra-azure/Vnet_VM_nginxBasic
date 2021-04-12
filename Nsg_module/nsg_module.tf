# Create Network Security Group ######
resource "azurerm_network_security_group" "nsg1" {
  name                = "${var.nsg_prefix}nsg1"
  location            = var.nsg_location
  resource_group_name = var.nsg_rg_name
  security_rule {
    name                       = "${var.nsg_prefix}sr1-server"
    priority                   = 1015
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
  security_rule {
    name                       = "${var.nsg_prefix}sr2-web"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "0.0.0.0/0"
    destination_address_prefix = "*"
  }
}

output "name" {
  value = azurerm_network_security_group.nsg1.name
}

output "nsgid" {
  value = azurerm_network_security_group.nsg1.id
}
