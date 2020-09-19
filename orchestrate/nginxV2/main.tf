
#local values
locals {
  vmName          = format("${var.resourcePrefix}-%s", "vm")
  nicName         = format("${var.resourcePrefix}-%s", "nic")
  pipName         = format("${var.resourcePrefix}-%s", "pip")
  nsgName         = format("${var.resourcePrefix}-%s", "nsg")
  managedDiskName = format("${var.resourcePrefix}-%s", "manageddisk")
}

#Calling Modules to create Nginx VM

module "azurepip" {
  source   = "../../infra/network/publicIP"
  pipName  = local.pipName
  azurerg  = data.azurerm_resource_group.azurerg.name
  location = data.azurerm_resource_group.azurerg.location
}

module "azurenetworkinterface" {
  source    = "../../infra/network/networkinterface"
  location  = data.azurerm_resource_group.azurerg.location
  subnetId  = data.azurerm_subnet.azurermsubnet.id
  pipId     = module.azurepip.azurepip
  nicName   = local.nicName
  azurerg   = data.azurerm_resource_group.azurerg.name
  azurevnet = data.azurerm_virtual_network.azurevnet.name
}

module "azurensg" {
  source   = "../../infra/network/networksecuritygroup/nsggroup"
  location = data.azurerm_resource_group.azurerg.location
  azurerg  = data.azurerm_resource_group.azurerg.name
  nsgName  = local.nsgName
}

module "azuremanageddisk" {
  source             = "../../infra/storage/managedDisk"
  location           = data.azurerm_resource_group.azurerg.location
  storageAccountType = var.storageAccountType
  diskSizeGb         = var.diskSizeGb
  azurerg            = data.azurerm_resource_group.azurerg.name
  managedDiskName    = local.managedDiskName
}

module "azurevirtualmachine" {
  source             = "../../infra/compute/virtualMachine"
  resourcePrefix     = var.resourcePrefix
  location           = data.azurerm_resource_group.azurerg.location
  vmName             = local.vmName
  vmSize             = var.vmSize
  vmUser             = var.vmUser
  nicID              = module.azurenetworkinterface.azurenic
  storageAccountType = var.storageAccountType
  azurerg            = data.azurerm_resource_group.azurerg.name
}

module "azuredatadiskattachment" {
  source           = "../../infra/storage/dataDiskAttachment"
  managedDiskId    = module.azuremanageddisk.datadiskid
  virtualMachineId = module.azurevirtualmachine.virtualmachineid
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
    content     = data.template_file.indexfile.rendered
    destination = "/tmp/index.html"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo cp /tmp/index.html /var/www/html/index.html",
      "sudo systemctl daemon-reload",
      "sudo systemctl restart nginx"
    ]
  }

  depends_on = [module.azuredatadiskattachment]
}

