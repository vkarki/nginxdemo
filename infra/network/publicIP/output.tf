output "azurepip" {
    value = azurerm_public_ip.azurepip.id
}

output "azurepipAddress" {
    value = azurerm_public_ip.azurepip.ip_address
}