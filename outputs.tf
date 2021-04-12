/*
### Vnet output ######
output "Vnet_CIDR" {
  value = module.Vnet_module.Vnet_CIDR
}

output "Subnet_CIDR" {
  value = module.Subnet_module.subnet_CIDR
}

output "subnet_id" {
  value = module.Subnet_module.subnet_id
}


output "os_sku" {
  value = lookup(var.sku, var.location)
}*/

output "VM_public_ip" {
  value = module.VM_module.public_ip
}
