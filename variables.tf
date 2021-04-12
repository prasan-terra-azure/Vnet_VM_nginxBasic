variable "location" {
  default = "eastus"
}

variable "prefix" {
  default = "practise1-"
}

variable "vnet_cidr" {
  default = "10.0.0.0/16"
}

### subnet variables####
variable "subnet_cidr" {
  type    = list(string)
  default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}

variable "subnet_name" {
  type    = list(string)
  default = ["subnet1", "subnet2", "subnet3"]
}

variable "sku" {
  default = {
    eastus  = "18.04-LTS"
    westus2 = "16.04-LTS"
    //southindia = "18.04-LTS"
  }
}

variable "admin_username" {
  default = "AzureUser"
}

variable "admin_password" {
  default = "Adminpas$123#"
}
