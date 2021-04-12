# Create Public IP
# Create public IP
resource "azurerm_public_ip" "publicip" {
  name                = "${var.vm_prefix}PublicIP"
  location            = var.vm_location
  resource_group_name = var.vm_rg_name
  allocation_method   = "Dynamic"
}

data "azurerm_public_ip" "ip" {
  name                = azurerm_public_ip.publicip.name
  resource_group_name = azurerm_virtual_machine.vm.resource_group_name
  depends_on          = [azurerm_virtual_machine.vm]
}

# Create network interface
resource "azurerm_network_interface" "nic" {
  name                = "${var.vm_prefix}NIC"
  location            = var.vm_location
  resource_group_name = var.vm_rg_name
  ip_configuration {
    name                          = "${var.vm_prefix}NICConfg"
    subnet_id                     = var.vm_subnetid
    private_ip_address_allocation = "dynamic"
    public_ip_address_id          = azurerm_public_ip.publicip.id
  }
}

resource "azurerm_network_interface_security_group_association" "nic-nsg" {
  network_interface_id      = azurerm_network_interface.nic.id
  network_security_group_id = var.vm_ngsid
}

# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                          = "${var.vm_prefix}Master"
  location                      = var.vm_location
  resource_group_name           = var.vm_rg_name
  network_interface_ids         = [azurerm_network_interface.nic.id]
  vm_size                       = "Standard_B2S"
  delete_os_disk_on_termination = true
  //tags                  = var.tags
  //  depends_on = [azurerm_network_interface.nic]

  storage_os_disk {
    name              = "${var.vm_prefix}OsDisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = lookup(var.sku, var.vm_location)
    version   = "latest"
  }

  os_profile {
    computer_name  = "${var.vm_prefix}-Web"
    admin_username = var.admin_username
    admin_password = var.admin_password
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "null_resource" "bootstrap" {
  connection {
    host     = data.azurerm_public_ip.ip.ip_address
    type     = "ssh"
    user     = var.admin_username
    password = var.admin_password
  }

  provisioner "remote-exec" {
    inline = [
      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do echo 'Waiting for cloud-init...'; sleep 1; done; sudo rm /var/lib/apt/lists/* ;",
      "sudo apt update -y && sudo apt install nginx -y",
      "sudo sleep 3",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx"
    ]
  }
}

output "public_ip" {
  value = data.azurerm_public_ip.ip.ip_address
}
