
# Create Resource Group
resource "azurerm_resource_group" "rg" {
  name     = "${var.prefix}rg"
  location = var.location
  tags = {
    Name = "${var.prefix}rg"
  }
}

############# Vnet Module #################
module "Vnet_module" {
  source                   = "./Vnet_module"
  vnet_prefix              = "${var.prefix}Vnet"
  vnet_address             = var.vnet_cidr
  vnet_location            = azurerm_resource_group.rg.location
  vnet_resource_group_name = azurerm_resource_group.rg.name
  tag_vnet_prefix          = "${var.prefix}Vnet"
}

############# Subnet Module #################
module "Subnet_module" {
  source       = "./Subnet_module"
  subnet_count = length(var.subnet_cidr)
  subnet_name  = var.subnet_name
  vnet_name    = module.Vnet_module.name
  rg_name      = azurerm_resource_group.rg.name
  subnet_addr  = var.subnet_cidr
  //depends_on   = [module.Vnet_module, azurerm_resource_group.rg] //module.Nsg_module]
}

############# NSG Module #################
module "Nsg_module" {
  source       = "./Nsg_module"
  nsg_prefix   = var.prefix
  nsg_location = azurerm_resource_group.rg.location
  nsg_rg_name  = azurerm_resource_group.rg.name
}

############# VM Module #################
module "VM_module" {
  source         = "./vm_module"
  vm_prefix      = var.prefix
  vm_location    = azurerm_resource_group.rg.location
  vm_rg_name     = azurerm_resource_group.rg.name
  vm_subnetid    = element(module.Subnet_module.subnet_id, 0) //data.azurerm_subnet.subnet1.id //module.Subnet_module.subnet_id //data.azurerm_subnet.subnet1.id
  vm_ngsid       = module.Nsg_module.nsgid                    //data.azurerm_subnet.subnet1.id
  admin_username = var.admin_username
  admin_password = var.admin_password
  sku            = var.sku
}
