provider "azurerm" {
  tenant_id       = "105b2061-b669-4b31-92ac-24d304d195dc"
  version         = "=2.0.0"
  features {}
}

terraform {
  required_version = ">= 0.12.0"
  backend "azurerm" {
  }
}
