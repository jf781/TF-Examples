variable "resource_group" {
  description = "Configuration for the Azure Resource Group."
  type = object({
    name     = string
    location = string
  })
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}

variable "managed_disks" {
  description = "Configuration for the Azure Managed Disk."
  type = list(object({
    name                 = string
    storage_account_type = string
    create_option        = string
    disk_size_gb         = number
    max_shares           = optional(number, null)
  }))
}
