resource "azurerm_managed_disk" "azuremanageddisk" {
  name                 = var.managedDiskName
  location             = var.location
  resource_group_name  = var.azurerg
  storage_account_type = var.storageAccountType
  create_option        = "Empty"
  disk_size_gb         = var.diskSizeGb
}