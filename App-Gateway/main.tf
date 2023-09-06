data "azurerm_client_config" "current" {}

data "azurerm_resource_group" "rg" {
  name = var.resourse_group_name
}

resource "azurerm_user_assigned_identity" "mi" {
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  name                = var.agw_managed_id
}

# resource "azurerm_role_assignment" "mi" {
#   scope                = data.azurerm_key_vault.main.id
#   role_definition_name = "Key Vault Administrator"
#   principal_id         = azurerm_user_assigned_identity.mi.principal_id
# }

# resource "time_sleep" "sleeptime" {
#   depends_on      = [azurerm_role_assignment.mi]
#   create_duration = "60s"
# }

resource "azurerm_key_vault_access_policy" "mi" {
  key_vault_id = data.azurerm_key_vault.main.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = azurerm_user_assigned_identity.mi.principal_id

  certificate_permissions = [
    "Get",
    "List"
  ]

  secret_permissions = [
    "Get",
    "List"
  ]
}