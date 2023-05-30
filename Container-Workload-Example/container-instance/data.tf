# Look up resource group
data "azurerm_resource_group" "rg" {
  name = var.resourse_group_name
}

# Pulls information about the subnet to associated the PostgreSQL Flexible Server
data "azurerm_subnet" "subnet" {
  name                 = var.container_group.subnet_name
  virtual_network_name = var.container_group.vnet_name
  resource_group_name  = var.container_group.vnet_rg_name
}

# Look up Log Analytics Workspace
data "azurerm_log_analytics_workspace" "laws" {
  name                = var.log_analytics_workspace.name
  resource_group_name = var.log_analytics_workspace.rg_name
}

# Look up Container Registry
data "azurerm_container_registry" "acr" {
  name                = var.container_registry.name
  resource_group_name = var.container_registry.resource_group_name
}

# Look up managed identity
data "azurerm_user_assigned_identity" "mi" {
  name                = var.container_group.identity_name
  resource_group_name = data.azurerm_resource_group.rg.name
}