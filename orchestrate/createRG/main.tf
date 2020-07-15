module "resourceGroup" {
  source          = "../../infra/misc/resourceGroup"
  resource_prefix = var.resource_prefix
  location        = var.location
}

module "vnet" {
  source          = "../../infra/misc/virtualNetwork"
  resource_prefix = var.resource_prefix
  resourceGroup   = module.resourceGroup.rgout
  location        = var.location
  address_space   = var.address_space
}