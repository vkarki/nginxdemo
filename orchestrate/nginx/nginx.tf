
#Read only data resources
data "azurerm_resource_group" "azurerg" {
  name = format("${var.resource_prefix}-%s", "rg")
}

data "azurerm_virtual_network" "azurevnet" {
  name                = format("${var.resource_prefix}-%s", "vnet")
  resource_group_name = data.azurerm_resource_group.azurerg.name
}

data "azurerm_public_ip" "azpip" {
  name                = format("${var.resource_prefix}-%s", "pip")
  resource_group_name = data.azurerm_resource_group.azurerg.name
  depends_on          = [module.azuredatadiskattachment]
}

#local values
locals {
  vmName         = format("${var.resource_prefix}-%s", "vm")
  azurerg         = format("${var.resource_prefix}-%s", "rg")
  azurevnet       = format("${var.resource_prefix}-%s", "vnet")
  nicName         = format("${var.resource_prefix}-%s", "nic")
  subnetName      = format("${var.resource_prefix}%s", "subnet")
  pipName         = format("${var.resource_prefix}-%s", "pip")
  nsgName         = format("${var.resource_prefix}-%s", "nsg")
  managedDiskName = format("${var.resource_prefix}-%s", "manageddisk")
}


#Calling Modules to create Nginx VM
module "azuresubnet" {
  source                = "../../infra/network/subnet"
  subnetName            = local.subnetName
  azurerg               = local.azurerg
  azurevnet             = local.azurevnet
  subnet_address_prefix = var.subnet_address_prefix
}

module "azurepip" {
  source   = "../../infra/network/publicIP"
  pipName  = local.pipName
  azurerg  = local.azurerg
  location = data.azurerm_resource_group.azurerg.location
}

module "azurenetworkinterface" {
  source    = "../../infra/network/networkinterface"
  location  = data.azurerm_resource_group.azurerg.location
  subnet_id = module.azuresubnet.subnet_id
  pip_id    = module.azurepip.azurepip
  nicName   = local.subnetName
  azurerg   = local.azurerg
  azurevnet = local.azurevnet
}

module "azurensg" {
  source   = "../../infra/network/networksecuritygroup/nsggroup"
  location = data.azurerm_resource_group.azurerg.location
  azurerg  = local.azurerg
  nsgName  = local.nsgName
}

module "azuremanageddisk" {
  source               = "../../infra/storage/managedDisk"
  location             = data.azurerm_resource_group.azurerg.location
  storage_account_type = var.storage_account_type
  disk_size_gb         = var.disk_size_gb
  azurerg              = local.azurerg
  managedDiskName      = local.managedDiskName
}

module "azurevirtualmachine" {
  source               = "../../infra/compute/virtualMachine"
  resource_prefix      = var.resource_prefix
  location             = data.azurerm_resource_group.azurerg.location
  vmName               = local.vmName
  vmSize               = var.vmSize
  vmUser               = var.vmUser
  nicID                = module.azurenetworkinterface.azurenic
  storage_account_type = var.storage_account_type
  azurerg  = local.azurerg
}

module "azuredatadiskattachment" {
  source             = "../../infra/storage/dataDiskAttachment"
  managed_disk_id    = module.azuremanageddisk.datadiskid
  virtual_machine_id = module.azurevirtualmachine.virtualmachineid
}

resource "null_resource" "enable-nginx" {
  connection {
    host     = data.azurerm_public_ip.azpip.ip_address
    user     = var.vmUser
    password = "p@zzW0rd12345"
  }
 
  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y",
      "sudo systemctl daemon-reload",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
    ]
  }
  
  provisioner "file" {
  source      = "./index.html"
  destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
      inline = [
        "sudo mv /tmp/index.html /var/www/html/index.html",
        "sudo systemctl restart nginx"
      ]
  }
  depends_on = [module.azuredatadiskattachment]
}
