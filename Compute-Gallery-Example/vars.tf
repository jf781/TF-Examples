variable "generalized_vm" {
  description = "The name of the virtual machine in which to create the resources."
  type        = object({
    name                = string
    resource_group_name = string
  })
}

variable "resource_group" {
  description = "The name of the resource group in which to create the resources."
  type        = object({
    name      = string
    location  = string
  })
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
}

variable "image_gallery" {
  description = "The name of the image gallery in which to create the resources."
  type        = object({
    name          = string
    description   = string
  })
}

variable "shared_image" {
  description = "The name of the image in which to create the resources."
  type        = object({
    name                          = string
    description                   = string
    os_type                       = string
    architecture                  = string
    hyper_v_generation            = string
    min_recommended_vcpu_count    = number
    max_recommended_vcpu_count    = number
    min_recommended_memory_in_gb  = number
    max_recommended_memory_in_gb  = number
    publisher                     = string
    offer                         = string
    sku                           = string
  })
}

variable "image_version" {
  description = "The name of the image version in which to create the resources."
  type        = object({
    name                = string
    target_region      = list(object({
      name                    = string
      regional_replica_count  = number
      storage_account_type    = string
    }))
  })
}

variable "image_name" {
  description = "The name of the image in which to create the resources."
  type        = string
}