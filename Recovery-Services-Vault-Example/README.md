# Terraform Recovery Services Vaults and Backup Policies


## Overview 

This will provide an example on how to configure a recovery services vault and assocaite VM backup policies with the vault. 

Resources deployed in this example
1. Resource Group
2. Recovery Services Vault
3. Multiple Backup Policies for VMs

This will deploy a single recovery vault and then configure multiple backup policies by using the `for-each` argument.  The variable `vm_backup_policies` is an list of objects with each example defining one backup policy.  Tearrform will loop through each object/policy defined in `vm_backup_policies` and create a backup policy and associate it with the recovery services vault.



## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.32.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_backup_policy_vm.policy](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/backup_policy_vm) | resource |
| [azurerm_recovery_services_vault.vault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/recovery_services_vault) | resource |
| [azurerm_resource_group.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_recovery_vault"></a> [recovery\_vault](#input\_recovery\_vault) | n/a | `map(string)` | <pre>{<br>  "cross_region_restore": "false",<br>  "name": "jf-demo-recovery-vault",<br>  "sku": "Standard",<br>  "soft_delete": "true",<br>  "storage_mode": "ZoneRedundant"<br>}</pre> | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"central us"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | n/a | `string` | `"demo-rg"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "tag key 1": "tag value 1",<br>  "tag key 2": "tag value 2",<br>  "tag key 3": "tag value 3"<br>}</pre> | no |
| <a name="input_vm_backup_policies"></a> [vm\_backup\_policies](#input\_vm\_backup\_policies) | n/a | <pre>list(object({<br>    name                            = string<br>    timezone                        = string<br>    policy_type                     = string # V1 or V2<br>    backup_frequency                = string # Hourly, Daily, or Weekly<br>    backup_start_time               = string<br>    backup_hour_interval            = number # Used if backup frequency is set to hourly<br>    backup_window_duration          = number # Used if backup frequency is set to houlry<br>    backup_weekdays                 = string # Used of backup frequency is set to weekly<br>    instant_restore_retention_days  = number<br>    retention_daily_count           = number<br>    retention_weekly_count          = number<br>    retention_weekly_weekeday       = string <br>    retention_monthly_count         = number<br>    retention_monthly_weekday       = string<br>    retention_monthly_week          = string<br>    retention_yearly_count          = number<br>    retention_yearly_weekday        = string<br>    retention_yearly_week           = string<br>    retention_yearly_month          = string<br>  }))</pre> | <pre>[<br>  {<br>    "backup_frequency": "Daily",<br>    "backup_hour_interval": null,<br>    "backup_start_time": "22:00",<br>    "backup_weekdays": null,<br>    "backup_window_duration": null,<br>    "instant_restore_retention_days": 3,<br>    "name": "Policy1",<br>    "policy_type": "V2",<br>    "retention_daily_count": 10,<br>    "retention_monthly_count": 60,<br>    "retention_monthly_week": "Last",<br>    "retention_monthly_weekday": "Sunday",<br>    "retention_weekly_count": 12,<br>    "retention_weekly_weekeday": "Sunday",<br>    "retention_yearly_count": 10,<br>    "retention_yearly_month": "December",<br>    "retention_yearly_week": "Last",<br>    "retention_yearly_weekday": "Sunday",<br>    "timezone": "Pacific Standard Time"<br>  },<br>  {<br>    "backup_frequency": "Hourly",<br>    "backup_hour_interval": 4,<br>    "backup_start_time": "22:00",<br>    "backup_weekdays": null,<br>    "backup_window_duration": 8,<br>    "instant_restore_retention_days": 3,<br>    "name": "Policy2",<br>    "policy_type": "V2",<br>    "retention_daily_count": 10,<br>    "retention_monthly_count": 60,<br>    "retention_monthly_week": "Last",<br>    "retention_monthly_weekday": "Sunday",<br>    "retention_weekly_count": 12,<br>    "retention_weekly_weekeday": "Sunday",<br>    "retention_yearly_count": 10,<br>    "retention_yearly_month": "December",<br>    "retention_yearly_week": "Last",<br>    "retention_yearly_weekday": "Sunday",<br>    "timezone": "Pacific Standard Time"<br>  },<br>  {<br>    "backup_frequency": "Weekly",<br>    "backup_hour_interval": null,<br>    "backup_start_time": "22:00",<br>    "backup_weekdays": "Sunday",<br>    "backup_window_duration": null,<br>    "instant_restore_retention_days": 3,<br>    "name": "Policy3",<br>    "policy_type": "V2",<br>    "retention_daily_count": null,<br>    "retention_monthly_count": 60,<br>    "retention_monthly_week": "Last",<br>    "retention_monthly_weekday": "Sunday",<br>    "retention_weekly_count": 12,<br>    "retention_weekly_weekeday": "Sunday",<br>    "retention_yearly_count": 10,<br>    "retention_yearly_month": "December",<br>    "retention_yearly_week": "Last",<br>    "retention_yearly_weekday": "Sunday",<br>    "timezone": "Pacific Standard Time"<br>  }<br>]</pre> | no |

## Outputs

No outputs.
