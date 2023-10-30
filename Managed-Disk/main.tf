# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}

# Managed Disk
resource "azurerm_managed_disk" "md" {
  for_each = { for disk in var.managed_disks :
               disk.name => disk }

  name                 = each.value.name
  location             = azurerm_resource_group.rg.location
  resource_group_name  = azurerm_resource_group.rg.name
  storage_account_type = each.value.storage_account_type
  create_option        = each.value.create_option
  disk_size_gb         = each.value.disk_size_gb
  max_shares           = each.value.max_shares
  tags                 = var.tags
}