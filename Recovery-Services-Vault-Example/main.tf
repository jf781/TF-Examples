# -------------------------------------------------------
# Managed Resources
# -------------------------------------------------------

# Resource Group 
resource "azurerm_resource_group" "example" {
  name     = var.rg_name
  tags     = var.tags
  location = var.region
}

resource "azurerm_recovery_services_vault" "vault" {
  name                          = var.recovery_vault.name
  location                      = azurerm_resource_group.example.location
  resource_group_name           = azurerm_resource_group.example.name
  sku                           = var.recovery_vault.sku
  storage_mode_type             = var.recovery_vault.storage_mode
  cross_region_restore_enabled  = var.recovery_vault.cross_region_restore
  soft_delete_enabled           = var.recovery_vault.soft_delete
  tags                          = var.tags
}


resource "azurerm_backup_policy_vm" "policy" {
  for_each            = { for policy in var.vm_backup_policies:
                          policy.name => policy }

  name                = each.value.name
  resource_group_name = azurerm_resource_group.example.name
  recovery_vault_name = azurerm_recovery_services_vault.vault.name

  timezone            = each.value.timezone
  policy_type         = each.value.policy_type

  backup {
    frequency     = each.value.backup_frequency
    time          = each.value.backup_start_time
    hour_interval = each.value.backup_hour_interval 
    hour_duration = each.value.backup_window_duration
    weekdays      = each.value.backup_weekdays != null ? [each.value.backup_weekdays] : null
  }

  dynamic "retention_daily" {
    for_each = { for retention_daily in var.vm_backup_policies:
                 "${retention_daily.name}-${retention_daily.retention_daily_count}" => retention_daily 
                 if retention_daily.backup_weekdays == null && retention_daily.name  == each.value.name}
    content {
      count = each.value.retention_daily_count
    }
  }

  retention_weekly {
    count    = each.value.retention_weekly_count
    weekdays = [each.value.retention_weekly_weekeday]
  }

  retention_monthly {
    count    = each.value.retention_monthly_count
    weekdays = [each.value.retention_monthly_weekday]
    weeks    = [each.value.retention_monthly_week]
  }

  retention_yearly {
    count    = each.value.retention_yearly_count
    weekdays = [each.value.retention_yearly_weekday]
    weeks    = [each.value.retention_yearly_week]
    months   = [each.value.retention_yearly_month]
  }
}
