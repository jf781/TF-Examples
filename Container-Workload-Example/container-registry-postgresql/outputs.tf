output "resource_group_name" {
  value = azurerm_resource_group.rg.name
}

output "container_registry_name" {
  value = azurerm_container_registry.acr.name
}

output "postgresql_server_name" {
  value = azurerm_postgresql_flexible_server.pg.name
}

output "azurerm_postgresql_flexible_server_database" {
  value = azurerm_postgresql_flexible_server_database.pgdb.id
}
