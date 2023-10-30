output "resource_group" {
  description = "The resource group details."
  value = {
    name     = azurerm_resource_group.rg.name
    location = azurerm_resource_group.rg.location
  }
  
}

output "managed_disks" {
  description = "The managed disks details."
  value = { for k, disk in azurerm_managed_disk.md : k => {
    name                 = disk.name
    storage_account_type = disk.storage_account_type
    create_option        = disk.create_option
    disk_size_gb         = disk.disk_size_gb
    max_shares           = disk.max_shares
  }}
  
}
