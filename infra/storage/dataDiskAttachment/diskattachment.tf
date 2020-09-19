resource "azurerm_virtual_machine_data_disk_attachment" "azuredatadiskattachment" {
  managed_disk_id    = var.managedDiskId
  virtual_machine_id = var.virtualMachineId
  lun                = 10
  caching            = "ReadWrite"
}