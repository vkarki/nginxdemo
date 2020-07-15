# provider "azurerm" {
#   subscription_id = "ebca5828-a112-484e-8180-d4a3720de5d0"
#   client_id       = var.service_principal_client_id
#   client_secret   = var.service_principal_client_secret
#   tenant_id       = "62703be7-f569-4700-ac06-129452b7d68e"
#   version         = "=2.0.0"
#   features {}
# }

# terraform {
#   required_version = ">= 0.12.0"
#   backend "azurerm" {
#     subscription_id      = "ebca5828-a112-484e-8180-d4a3720de5d0"
#     tenant_id            = "62703be7-f569-4700-ac06-129452b7d68e"
#     resource_group_name  = "terraformbackend"
#     storage_account_name = "azurebackendterrstracc"
#     container_name       = "backendcontainer"
#     key                  = "nginx-dev.tfstate"
#     access_key           = "5JzTs5j9miyFNxYQyemLJXr1PkOP+PYH+dZjFItbBGGiNPZomssQ0ZC+l0/PF0Q0dRLwtmrGemsiSXpNQTCrUA=="
#   }
# }


provider "azurerm" {
  subscription_id = "ebca5828-a112-484e-8180-d4a3720de5d0"
  tenant_id       = "62703be7-f569-4700-ac06-129452b7d68e"
  version         = "=2.0.0"
  features {}
}

terraform {
  required_version = ">= 0.12.0"
  backend "azurerm" {
    subscription_id      = "ebca5828-a112-484e-8180-d4a3720de5d0"
    tenant_id            = "62703be7-f569-4700-ac06-129452b7d68e"
    resource_group_name  = "terraformbackend"
    storage_account_name = "azurebackendterrstracc"
    container_name       = "backendcontainer"
    key                  = "nginx.tfstate"
    #access_key           = "5JzTs5j9miyFNxYQyemLJXr1PkOP+PYH+dZjFItbBGGiNPZomssQ0ZC+l0/PF0Q0dRLwtmrGemsiSXpNQTCrUA=="
  }
}
