
locals {
  rgName = format("${var.resource_prefix}-%s", "rg")
}

resource "azurerm_resource_group" "rg" {
  name     = local.rgName
  location = var.location
}