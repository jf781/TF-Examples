resource_group = {
  name     = "joefecht-managed-disk-example"
  location = "East US 2"
}

tags = {
  Environment = "Dev"
  Owner       = "Joe Fecht"
}

managed_disks = [
  {
    name                 = "example_managed_disk01"
    storage_account_type = "Premium_LRS"
    create_option        = "Empty"
    disk_size_gb         = 50
    max_shares           = 2
  },
  {
    name                 = "example_managed_disk02"
    storage_account_type = "Premium_LRS"
    create_option        = "Empty"
    disk_size_gb         = 1024
    max_shares           = 3
  },
  {
    name                 = "example_managed_disk03"
    storage_account_type = "Premium_LRS"
    create_option        = "Empty"
    disk_size_gb         = 512
  }
]