# Pulls the current AAD tenant information
data "azurerm_client_config" "current" {}

# Pulls information about the AAD Group that will be the admin
data "azuread_group" "pg-admin" {
  display_name = var.postgresql_server.authentication.active_directory_admin_group_name
}

# Pulls information about the subnet to associated the PostgreSQL Flexible Server
data "azurerm_subnet" "pg-subnet" {
  name                 = var.postgresql_server.delegated_subnet_name
  virtual_network_name = var.postgresql_server.delegated_vnet_name
  resource_group_name  = var.postgresql_server.delegated_vnet_rg_name
}

# Pulls information about the subnet to associated the PostgreSQL Flexible Server
data "azurerm_subnet" "acr-subnet" {
  count                = length(var.container_registry.subnet_name) > 0 ? 1 : 0
  name                 = var.container_registry.subnet_name
  virtual_network_name = var.container_registry.vnet_name
  resource_group_name  = var.container_registry.vnet_rg_name
}

# Pulls information about the private DNS zone to associate the PostgreSQL Flexible Server
data "azurerm_private_dns_zone" "pg-dns-zone" {
  name                = var.postgresql_server.private_dns_zone_name
  resource_group_name = var.postgresql_server.private_dns_zone_rg_name
}

# Pulls Key Vault for PostgreSQL Flexible Server
data "azurerm_key_vault" "pg" {
  name                = var.postgresql_server.admin_secret_key_vault_name
  resource_group_name = var.postgresql_server.admin_secret_key_vault_rg_name
}

# Pulls Secret from Key Vault for PostgreSQL Flexible Server
data "azurerm_key_vault_secret" "pg" {
  name         = var.postgresql_server.admin_secret_name
  key_vault_id = data.azurerm_key_vault.pg.id
}