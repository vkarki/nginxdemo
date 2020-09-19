
#Read only data resources
data "azurerm_resource_group" "azurerg" {
  name = format("${var.resourcePrefix}-%s", "rg")
}

data "azurerm_virtual_network" "azurevnet" {
  name                = format("${var.resourcePrefix}-%s", "vnet")
  resource_group_name = data.azurerm_resource_group.azurerg.name
}

data "azurerm_subnet" "azurermsubnet" {
  name                 = format("${var.resourcePrefix}-%s", "subnet")
  virtual_network_name = data.azurerm_virtual_network.azurevnet.name
  resource_group_name  = data.azurerm_resource_group.azurerg.name
}

data "azurerm_public_ip" "azpip" {
  name                = format("${var.resourcePrefix}-%s", "pip")
  resource_group_name = data.azurerm_resource_group.azurerg.name
  depends_on          = [module.azuredatadiskattachment]
}

data "template_file" "indexfile" {
  template = "${file("${path.module}/template/index.tpl")}"
  vars = {
    applicationName = var.applicationName
    privateIP       = element(module.azurenetworkinterface.azureprivip, 0)
    publicIP        = data.azurerm_public_ip.azpip.ip_address
    vmName          = local.vmName
  }
  depends_on = [module.azuredatadiskattachment]
}

