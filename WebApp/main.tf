# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = local.tags
}

# App Service Plan
resource "azurerm_service_plan" "asp" {
  name                = var.app_service_plan.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  os_type             = var.app_service_plan.os_type
  tags                = local.tags

  sku_name = var.app_service_plan.sku_name
}

# App Service
resource "azurerm_linux_web_app" "web" {
  name                = var.app_service.name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.asp.id
  tags                = local.tags

  site_config {
    worker_count  = var.app_service.site_settings.worker_count
    always_on     = var.app_service.site_settings.always_on
    http2_enabled = var.app_service.site_settings.http2_enabled

    application_stack {
      docker_image_name   = var.app_service.application_stack.docker_image_name
      docker_registry_url = var.app_service.application_stack.docker_registry_url
    }
  }

}