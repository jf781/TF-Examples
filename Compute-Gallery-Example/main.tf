# --------------------------------------------------------------
# Unmanaged Resources
# --------------------------------------------------------------

# VM must be generalized before running this script
data "azurerm_virtual_machine" "existing_vm" {
  name                = var.generalized_vm.name
  resource_group_name = var.generalized_vm.resource_group_name
}

# --------------------------------------------------------------
# Managed Resources
# --------------------------------------------------------------

# Resource Group 
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}

# Define Shared Image Gallery
resource "azurerm_shared_image_gallery" "gallery" {
  name                = var.image_gallery.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  tags                = var.tags

  description         = var.image_gallery.description
}

# Defines the actual image from the VM
resource "azurerm_image" "image" {
  name                      = var.image_name
  resource_group_name       = azurerm_resource_group.rg.name
  location                  = azurerm_resource_group.rg.location
  source_virtual_machine_id = data.azurerm_virtual_machine.existing_vm.id
  tags                      = var.tags
}

# Define Shared Image
resource "azurerm_shared_image" "shared_image" {
  name                          = var.shared_image.name
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  tags                          = var.tags

  gallery_name                  = azurerm_shared_image_gallery.gallery.name
  os_type                       = var.shared_image.os_type 
  description                   = var.shared_image.description
  architecture                  = var.shared_image.architecture
  hyper_v_generation            = var.shared_image.hyper_v_generation

  min_recommended_vcpu_count    = var.shared_image.min_recommended_vcpu_count
  max_recommended_vcpu_count    = var.shared_image.max_recommended_vcpu_count
  min_recommended_memory_in_gb  = var.shared_image.min_recommended_memory_in_gb
  max_recommended_memory_in_gb  = var.shared_image.max_recommended_memory_in_gb

  identifier {
    publisher = var.shared_image.publisher
    offer     = var.shared_image.offer
    sku       = var.shared_image.sku
  }
}

# Define Shared Image Version
resource "azurerm_shared_image_version" "image_version" {
  name                = var.image_version.name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  gallery_name        = azurerm_shared_image_gallery.gallery.name
  image_name          = azurerm_shared_image.shared_image.name
  tags                = var.tags

  managed_image_id    = azurerm_image.image.id

  dynamic target_region {
    for_each = var.image_version.target_region
    content {
      name                   = target_region.value.name
      regional_replica_count = target_region.value.regional_replica_count
      storage_account_type   = target_region.value.storage_account_type
    }
  }
}