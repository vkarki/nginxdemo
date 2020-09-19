resource "azurerm_network_interface" "azurenic" {
  name                = var.nicName
  location            = var.location
  resource_group_name = var.azurerg

  ip_configuration {
    name                          = var.nicName
    subnet_id                     = var.subnetId
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = var.pipId
  }
}
