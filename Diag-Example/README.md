# Terraform Diagnostic Settings 


## Overview

This will provide an example on how to configure diagnostic settings for a Key Vault.   The resource `azurerm_monitor_diagnostic_setting` can be used to apply diagnostic settings against other resources in Azure (it's not specific to a key vault).

Resources deployed in this example
1. Resource Group
2. Key Vault
3. Log Analytics workspace
4. Event Hub
5. Event Hub Namespace
6. Event Hub Namespace Authorization Rule
7. Diagnostic Settings for Key Vault

Once all resources are deployed then the `azurerm_monitor_diagnostic_setting` resource is used to configure the diagnostic settings on the key vault.  It will send the data to both the log analytics workspace and event hub as shown below:

```terraform
log_analytics_workspace_id      = azurerm_log_analytics_workspace.example.id
eventhub_name                   = var.eh_name
eventhub_authorization_rule_id  = azurerm_eventhub_namespace_authorization_rule.example.id
```


You can configure the various diagnostic settings by using the `logs` and `metrics` blocks within the diagnostic settings.  

As shown in this example, we are defining the logs for `AuditEvent`, `AzurePolicyEvaluationDetails`, and `AllMetrics`. 

```terraform
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
```

There will typically only be one `metric` block.   However there can be multiple `log` blocks depending on the resource type.  You can configure multiple `log` blocks as needed for each resource type.   Please see this [list](https://learn.microsoft.com/en-us/azure/azure-monitor/essentials/resource-logs-categories) for a full list of resource types and an associated logs available with each resource type. 



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
| [azurerm_eventhub.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub) | resource |
| [azurerm_eventhub_namespace.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace) | resource |
| [azurerm_eventhub_namespace_authorization_rule.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/eventhub_namespace_authorization_rule) | resource |
| [azurerm_key_vault.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault) | resource |
| [azurerm_log_analytics_workspace.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_resource_group.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_client_config.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_eh_name"></a> [eh\_name](#input\_eh\_name) | n/a | `string` | `"demo-eh"` | no |
| <a name="input_eh_namespace"></a> [eh\_namespace](#input\_eh\_namespace) | n/a | `string` | `"demo-ehns"` | no |
| <a name="input_key_vault_diag_settings"></a> [key\_vault\_diag\_settings](#input\_key\_vault\_diag\_settings) | n/a | `map(string)` | <pre>{<br>  "allMetrics": "false",<br>  "auditEvent": "true",<br>  "azurePolicyEvaulationDetails": "true",<br>  "name": "Demo Diag Settings Name"<br>}</pre> | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | n/a | `string` | `"jf-demo-test-vault"` | no |
| <a name="input_laws_name"></a> [laws\_name](#input\_laws\_name) | n/a | `string` | `"demo-laws"` | no |
| <a name="input_pip_name"></a> [pip\_name](#input\_pip\_name) | n/a | `string` | `"demo-pip"` | no |
| <a name="input_region"></a> [region](#input\_region) | n/a | `string` | `"central us"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | n/a | `string` | `"demo-rg"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "tag key 1": "tag value 1",<br>  "tag key 2": "tag value 2",<br>  "tag key 3": "tag value 3"<br>}</pre> | no |

## Outputs

No outputs.
