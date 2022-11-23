# -------------------------------------------------------
# Unmanaged Resources
# -------------------------------------------------------

data "azurerm_client_config" "current" {}

# -------------------------------------------------------
# Managed Resources
# -------------------------------------------------------

# Resource Group 
resource "azurerm_resource_group" "example" {
  name     = var.rg_name
  tags     = var.tags
  location = var.region
}


# Key Vault
resource "azurerm_key_vault" "example" {
  name                        = var.key_vault_name
  location                    = azurerm_resource_group.example.location
  resource_group_name         = azurerm_resource_group.example.name
  sku_name                    = "standard"
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  tags                        = var.tags  

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }
}


# Define Resources to receive logs
resource "azurerm_log_analytics_workspace" "example" {
  name                = var.laws_name
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
  tags                = var.tags  
}

resource "azurerm_eventhub_namespace" "example" {
  name                = var.eh_namespace
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Standard"
  capacity            = 1
  tags                = var.tags  
}

resource "azurerm_eventhub_namespace_authorization_rule" "example" {
  name                = "${var.eh_namespace}-auth-rule"
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name

  listen = true
  send   = true
  manage = false
}

resource "azurerm_eventhub" "example" {
  name                = var.eh_name
  namespace_name      = azurerm_eventhub_namespace.example.name
  resource_group_name = azurerm_resource_group.example.name
  partition_count     = 2
  message_retention   = 1
}


# Configure Diagnostic Settings
resource "azurerm_monitor_diagnostic_setting" "example" {
  name                            = var.key_vault_diag_settings.name
  target_resource_id              = azurerm_key_vault.example.id

  log_analytics_workspace_id      = azurerm_log_analytics_workspace.example.id
  eventhub_name                   = var.eh_name
  eventhub_authorization_rule_id  = azurerm_eventhub_namespace_authorization_rule.example.id


  log {
    category = "AuditEvent"
    enabled  = var.key_vault_diag_settings.auditEvent

    retention_policy {
      enabled = false
    }
  }

  log {
    category = "AzurePolicyEvaluationDetails"
    enabled  = var.key_vault_diag_settings.azurePolicyEvaulationDetails

    retention_policy {
      enabled = false
    }
  }


  metric {
    category  = "AllMetrics"
    enabled   = var.key_vault_diag_settings.allMetrics

    retention_policy {
      enabled = false
    }
  }
}