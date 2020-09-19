
provider "azurerm" {
  tenant_id = "105b2061-b669-4b31-92ac-24d304d195dc"
  version   = ">=2.21.0"
  features {}
}

terraform {
  required_version = ">= 0.12.0"
  backend "azurerm" {
    subscription_id      = "b0199e68-059a-47f0-a685-74588c223168"
    tenant_id            = "105b2061-b669-4b31-92ac-24d304d195dc"
    resource_group_name  = "terraformDemo-rg"
    storage_account_name = "demotfbackend"
    container_name       = "tfstate"
    key                  = "nginxDev.tfstate"
  }
}
