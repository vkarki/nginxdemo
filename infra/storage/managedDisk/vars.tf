variable "location" {
    type = string
    description = "location for the resource to be placed"
}

variable "storageAccountType" {
    type = string
    description = "Describe storage account type"
}

variable "diskSizeGb" {
    type = string
    description = "Size of managed disk"
}

variable "azurerg" {
    type = string
    description = "resource group name"
}

variable "managedDiskName" {
    type = string
    description = "Data disk name"
}