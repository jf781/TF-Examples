# Define a resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group.name
  location = var.resource_group.location
  tags     = var.tags
}

# Define a container registry
resource "azurerm_container_registry" "acr" {
  name                          = var.container_registry.name
  resource_group_name           = azurerm_resource_group.rg.name
  location                      = azurerm_resource_group.rg.location
  sku                           = var.container_registry.sku
  admin_enabled                 = var.container_registry.admin_enabled
  public_network_access_enabled = var.container_registry.public_network_access_enabled
  tags                          = var.tags

  dynamic "network_rule_set" {
    for_each = var.container_registry.public_network_access_enabled ? [] : [1]
    content {
      virtual_network {
        action    = "Allow"
        subnet_id = data.azurerm_subnet.acr-subnet[0].id
      }
    }
  }

  dynamic "georeplications" {
    for_each = var.container_registry.georeplication
    content {
      location                = georeplications.value.name
      zone_redundancy_enabled = georeplications.value.zone_redundancy
      tags                    = georeplications.value.tags
    }
  }
}

# Create a user managed identity
resource "azurerm_user_assigned_identity" "mi" {
  name                = var.acr-mananged-identity
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  tags                = var.tags
}

# Assign the user managed identity to the container registry
resource "azurerm_role_assignment" "ra" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.mi.principal_id
}

# Define a private endpoint
resource "azurerm_private_endpoint" "acr-pe" {
  name                = join("-", [var.container_registry.name, "pe"])
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  subnet_id           = data.azurerm_subnet.acr-subnet[0].id
  tags                = var.tags

  private_service_connection {
    name                           = var.container_registry.name
    is_manual_connection           = false
    private_connection_resource_id = azurerm_container_registry.acr.id
    subresource_names              = ["registry"]
  }

  private_dns_zone_group {
    name                 = var.container_registry.private_dns_zone_name
    private_dns_zone_ids = [data.azurerm_private_dns_zone.acr-dns-zone.id]
  }
}


# Define a postgresql flexible server
resource "azurerm_postgresql_flexible_server" "pg" {
  name                   = var.postgresql_server.name
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = var.postgresql_server.version
  sku_name               = var.postgresql_server.sku_name
  storage_mb             = var.postgresql_server.storage_mb
  zone                   = var.postgresql_server.zone
  administrator_login    = var.postgresql_server.admin_secret_name
  administrator_password = data.azurerm_key_vault_secret.pg.value
  delegated_subnet_id    = data.azurerm_subnet.pg-subnet.id
  private_dns_zone_id    = data.azurerm_private_dns_zone.pg-dns-zone.id
  tags                   = var.tags

  authentication {
    active_directory_auth_enabled = var.postgresql_server.authentication.active_directory_auth_enabled
    password_auth_enabled         = var.postgresql_server.authentication.password_auth_enabled
    tenant_id                     = data.azurerm_client_config.current.tenant_id
  }

}

# Defines the Active Directory Administrator for the PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server_active_directory_administrator" "pg" {
  server_name         = azurerm_postgresql_flexible_server.pg.name
  resource_group_name = azurerm_resource_group.rg.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azuread_group.pg-admin.object_id
  principal_name      = data.azuread_group.pg-admin.display_name
  principal_type      = "Group"
}


# Defines the firewall rules for the PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server_firewall_rule" "pg" {
  for_each = { for rule in var.postgresql_server_firewall_rules :
  rule.name => rule }

  name             = each.value.name
  server_id        = azurerm_postgresql_flexible_server.pg.id
  start_ip_address = each.value.start_ip_address
  end_ip_address   = each.value.end_ip_address
}


# Define a postgresql database
resource "azurerm_postgresql_flexible_server_database" "pgdb" {
  name      = var.postgresql_database.name
  server_id = azurerm_postgresql_flexible_server.pg.id
  charset   = var.postgresql_database.charset
  collation = var.postgresql_database.collation
}

