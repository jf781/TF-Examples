#----------------------------------------------------------
# Data managed outside of this TF module 
#----------------------------------------------------------

### Vnet/Subnet Configuration
data "azurerm_subnet" "listener" {
  name                 = var.agw_subnet.subnetName
  resource_group_name  = var.agw_subnet.vnetRgName
  virtual_network_name = var.agw_subnet.vnetName
}

### Certificate Key Vault Configuration
data "azurerm_key_vault" "main" {
  name                = var.key_vault.vault_name
  resource_group_name = var.key_vault.vault_rg_name
}

data "azurerm_key_vault_certificate" "cert" {
  name         = var.agw_ssl_certificate
  key_vault_id = data.azurerm_key_vault.main.id
}

# data "azurerm_key_vault_secret" "trusted_root" {
#   name         = var.agw_ssl_trusted_root_secret_name
#   key_vault_id = data.azurerm_key_vault.main.id
# }

# ### Log Analytics Workspace
# data "azurerm_log_analytics_workspace" "law" {
#   name                = var.lawWorkspaceName
#   resource_group_name = var.lawWorkspaceRgName
# }

# ### EventHub
# data "azurerm_eventhub_namespace_authorization_rule" "eh_rule" {
#   name                = var.eventHub.eventHub_authorization_rule_name
#   namespace_name      = var.eventHub.eventHub_namespace
#   resource_group_name = var.eventHub.eventHub_rg_name
# }

#----------------------------------------------------------
# Resources managed by this TF module 
#----------------------------------------------------------

# ### Public IP
# resource "azurerm_public_ip" "appGw" {
#   name                = "${var.agw_basename}-PubIP"
#   resource_group_name = data.azurerm_resource_group.rg.name
#   location            = data.azurerm_resource_group.rg.location
#   allocation_method   = "Static"
#   sku                 = "Standard"
#   tags                = merge(var.tags, data.azurerm_resource_group.rg.tags)
# }

### Application Gateway
resource "azurerm_application_gateway" "main" {
  name                = var.agw_basename
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  tags                = merge(var.tags, data.azurerm_resource_group.rg.tags)

  ### SKU 
  sku {
    name = var.agw_sku.name
    tier = var.agw_sku.tier
    # capacity  = var.agw_sku.capacity - Not require since we are using AutoScaling. 
  }

  ### Define the Autoscale configuration
  autoscale_configuration {
    min_capacity = var.agw_min_capacity
    max_capacity = var.agw_max_capacity
  }


  ### User assigned managed identity of App Gateway
  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.mi.id]
  }

  zones = var.agw_availability_zone_count

  ### WAF Policy 
  # firewall_policy_id = azurerm_web_application_firewall_policy.waf.id

  ### Defint the SSL Policy
  dynamic "ssl_policy" {
    for_each = var.ssl_policy
    content {
      policy_type          = ssl_policy.value["policy_type"]
      min_protocol_version = try(ssl_policy.value["min_protocol_version"], null)
      cipher_suites        = try(ssl_policy.value["cipher_suites"], null)
      policy_name          = try(ssl_policy.value["policy_name"], null)
    }
  }

  ### Define the subnet that the Application Gateway will be deployed to 
  gateway_ip_configuration {
    name      = var.gateway_ip_configuration_name
    subnet_id = data.azurerm_subnet.listener.id
  }

  ### Define Front end Public IP
  frontend_ip_configuration {
    name                          = var.frontend_ip_configuration.name
    subnet_id                     = try(var.frontend_ip_configuration.subnet_id, null)
    private_ip_address_allocation = try(var.frontend_ip_configuration.private_ip_address_allocation, null)
    private_ip_address            = try(var.frontend_ip_configuration.private_ip_address, null)
    # public_ip_address_id          = try(azurerm_public_ip.appGw.id, null)
  }

  ### Define front end listener ports
  frontend_port {
    name = var.frontend_port_name_HTTP
    port = 80
  }

  frontend_port {
    name = var.frontend_port_name_HTTPS
    port = 443
  }

  ### Define SSL cert for Listeners 
  ssl_certificate {
    name                = var.agw_ssl_certificate
    key_vault_secret_id = data.azurerm_key_vault_certificate.cert.secret_id
  }

  ### Defining the HTTP Listeners
  dynamic "http_listener" {
    for_each = var.agw_listeners
    content {
      name                           = http_listener.value["name"]
      frontend_ip_configuration_name = http_listener.value["frontend_ip_configuration_name"]
      frontend_port_name             = http_listener.value["frontend_port_name"]
      protocol                       = http_listener.value["protocol"]
      ssl_certificate_name           = http_listener.value["ssl_certificate_name"]
      host_name                      = http_listener.value["fqdn"]
      require_sni                    = http_listener.value["require_sni"]
    }
  }

  ### Create Backend Address Pool
  dynamic "backend_address_pool" {
    for_each = var.agw_backend_address_pool
    content {
      name = backend_address_pool.value["name"]
      ip_addresses = try(backend_address_pool.value["be_target_ips"], null)
      fqdns = try(backend_address_pool.value["be_target_fqdns"], null)
    }
  }

  ### Configure Trusted Root Certificate
  # trusted_root_certificate {
  #   name = var.agw_ssl_certificate
  #   data = data.azurerm_key_vault_secret.trusted_root.value # var.agw_ssl_trusted_root_data 
  # }


  ## Configure health probes
  dynamic "probe" {
    for_each = var.agw_health_probe
    content {
      name                                      = probe.value["probe_name"]
      host                                      = probe.value["probe_host"]
      protocol                                  = probe.value["probe_protocol"]
      path                                      = probe.value["probe_path"]
      interval                                  = probe.value["probe_interval"]
      timeout                                   = probe.value["probe_timeout"]
      unhealthy_threshold                       = probe.value["probe_unhealthy_threshold"]
      minimum_servers                           = probe.value["probe_minimum_servers"]
      pick_host_name_from_backend_http_settings = probe.value["probe_pick_host_name_from_backend_http_settings"]

      match {
        body        = probe.value["probe_match_body"]
        status_code = probe.value["probe_status_code"]
      }
    }
  }

  ### Define the HTTP Backend Settings
  dynamic "backend_http_settings" {
    for_each = var.agw_backend_http_settings
    content {
      name                                = backend_http_settings.value["name"]
      host_name                           = backend_http_settings.value["host_name"]
      cookie_based_affinity               = backend_http_settings.value["cookie_based_affinity"]
      affinity_cookie_name                = backend_http_settings.value["affinity_cookie_name"]
      port                                = backend_http_settings.value["port"]
      protocol                            = backend_http_settings.value["protocol"]
      request_timeout                     = backend_http_settings.value["request_timeout"]
      probe_name                          = backend_http_settings.value["probe_name"]
      pick_host_name_from_backend_address = backend_http_settings.value["pick_host_name_from_backend_address"]

      connection_draining {
        enabled           = backend_http_settings.value["connection_draining_enabled"]
        drain_timeout_sec = backend_http_settings.value["connection_draining_timeout_sec"]
      }
    }
  }

  ### Defining any optional redirect settings
  dynamic "redirect_configuration" {
    for_each = var.agw_redirect_config
    content {
      name                 = redirect_configuration.value["name"]
      redirect_type        = redirect_configuration.value["redirect_type"]
      target_listener_name = redirect_configuration.value["target_listener_name"]
      include_path         = redirect_configuration.value["include_path"]
      include_query_string = redirect_configuration.value["include_query_string"]
    }
  }

  ### Routing Rules
  # Defining HTTP to HTTPS redirect
  dynamic "request_routing_rule" {
    for_each = var.agw_enable_redirect ? var.agw_routing_rules_http : []
    content {
      name                        = request_routing_rule.value["name"]
      priority                    = request_routing_rule.value["priority"]
      rule_type                   = request_routing_rule.value["rule_type"]
      http_listener_name          = request_routing_rule.value["http_listener_name"]
      redirect_configuration_name = request_routing_rule.value["redirect_configuration_name"]
    }
  }

  #HTTP without Redirect
  dynamic "request_routing_rule" {
    for_each = var.agw_enable_redirect ? [] : var.agw_routing_rules_http
    content {
      name                       = request_routing_rule.value["name"]
      priority                   = request_routing_rule.value["priority"]
      rule_type                  = request_routing_rule.value["rule_type"]
      http_listener_name         = request_routing_rule.value["http_listener_name"]
      backend_address_pool_name  = request_routing_rule.value["backend_address_pool_name"]
      backend_http_settings_name = request_routing_rule.value["backend_http_settings_name"]
    }
  }

  #HTTPS
  dynamic "request_routing_rule" {
    for_each = var.agw_routing_rules_https
    content {
      name                       = request_routing_rule.value["name"]
      priority                   = request_routing_rule.value["priority"]
      rule_type                  = request_routing_rule.value["rule_type"]
      http_listener_name         = request_routing_rule.value["http_listener_name"]
      backend_address_pool_name  = request_routing_rule.value["backend_address_pool_name"]
      backend_http_settings_name = request_routing_rule.value["backend_http_settings_name"]
    }
  }

  enable_http2 = true

}

# data "azurerm_network_interface" "be_pool_target" {
#   for_each            = { for target in var.bePoolTargets:
#                             target.nicName => target }
#   name                = each.value.nicName
#   resource_group_name = each.value.nicRgName
# }

# resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "be_pool" {
#   for_each = { for target in var.windowsVMs :
#     target.name => target
#   if target.productionReady == true }

#   network_interface_id    = azurerm_network_interface.windows[each.value.name].id
#   ip_configuration_name   = "internal"
#   backend_address_pool_id = azurerm_application_gateway.main.backend_address_pool[0].id
# }

### Diagnostic Settings
# resource "azurerm_monitor_diagnostic_setting" "diag_settings" {
#   name                            = var.diagSettingsName
#   target_resource_id              = azurerm_application_gateway.main.id
#   log_analytics_workspace_id      = data.azurerm_log_analytics_workspace.law.id
#   # eventhub_name                   = var.eventHub.eventHub_name
#   # eventhub_authorization_rule_id  = data.azurerm_eventhub_namespace_authorization_rule.eh_rule.id

#   log {
#     category  = "ApplicationGatewayAccessLog"
#     enabled   = false

#     retention_policy {
#       days = "0"
#       enabled = false
#     }
#   }

#   log {
#     category  = "ApplicationGatewayPerformanceLog"
#     enabled   = true

#     retention_policy {
#       days = "0"
#       enabled = false
#     }
#   }

#   log {
#     category  = "ApplicationGatewayFirewallLog"
#     enabled   = true

#     retention_policy {
#       days = "0"
#       enabled = false
#     }
#   }

#   metric {
#     category = "AllMetrics"
#     enabled = true

#     retention_policy {
#       days = "0"
#       enabled = false
#     }
#   }
# }
