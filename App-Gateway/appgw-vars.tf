#--------------------------------------------------------
# Applicaion Gateway - Existing environment details 
#--------------------------------------------------------

### a

### Vnet/Subnet
variable "agw_subnet" {
  description = "Vnet that the AG will be associated with"
  type        = map(string)
  default = {
    vnetName   = "vnet01"
    vnetRgName = "jf-lab"
    subnetName = "AGW"
  }
}

### Managed ID for KeyVault Access
variable "agw_managed_id" {
  description = "Used by Application Gateway to access the key vault"
  default     = "ag-prod01-mi"
}

variable "key_vault" {
  description = "Key Vault that contains cert and passkey"
  type        = map(string)
  default = {
    vault_name    = "jfkv01"
    vault_rg_name = "jf-lab"
  }
}

#--------------------------------------------------------
# Applicaion Gateway - Backend Pool 
#--------------------------------------------------------

variable "bePoolTargets" {
  description = "Defines backend pool targets"
  type = list(object({
    nicName   = string
    ipConfig  = string
    nicRgName = string
  }))
  default = [
    # {
    #   nicName   = "sptsweb03_nic"
    #   ipConfig  = "ipconfig1"
    #   nicRgName = "COREproduction"
    # },
    {
      nicName   = "sptsweb04_nic1"
      ipConfig  = "ipconfig1"
      nicRgName = "COREproduction"
    },
    {
      nicName   = "sptsweb-terraform-nic"
      ipConfig  = "internal"
      nicRgName = "COREproduction"
    },
    {
      nicName   = "sptsweb-terraform2-nic"
      ipConfig  = "internal"
      nicRgName = "COREproduction"
    },
    {
      nicName   = "sptsweb-terraform4-nic"
      ipConfig  = "internal"
      nicRgName = "COREproduction"
    },
    {
      nicName   = "sptsweb-terraform3-nic"
      ipConfig  = "internal"
      nicRgName = "COREproduction"
    }
  ]
}

#--------------------------------------------------------
# Applicaion Gateway - Diagnostics Settings
#--------------------------------------------------------

# variable "logAnalyticsWorkspace" {
#   description = "Log Analytics Workspace to send logs to"
#   type        = map(string)
#   default     = {
#     workspace_name    = "DefaultWorkspace-12682e9b-5a22-4f22-8a56-7c2b6d65dc97-EUS"
#     workspace_rg_name = "defaultresourcegroup-eus"
#   }
# }

# variable "diagSettingsName" {
#   description = "Diagnostic settings name"
#   type        = string
#   default     = "ag-prod01-diagSettings"
# }

# variable "eventHub" {
#   description = "EventHub name to send logs to"
#   type        = map(string)
#   default     = {
#     eventHub_namespace                = "stageagalerts"
#     eventHub_name                     = "stage0_waf"
#     eventHub_rg_name                  = "Stage0_WAF"
#     eventHub_authorization_rule_name  = "RootManageSharedAccessKey"

#   }
# }



#--------------------------------------------------------
# Applicaion Gateway - General Settings
#--------------------------------------------------------

#### App Gateway Basics
variable "agw_basename" {
  description = "Application Gateway name"
  type        = string
  default     = "agw01"
}

variable "agw_sku" {
  description = "Sizing for the Application Gateway"
  type        = map(string)
  default = {
    name = "Standard_v2"
    tier = "Standard_v2"
  }
}


#### App Gateway Sizing and availability zone config
variable "agw_min_capacity" {
  description = "Application Gateway mininum capacity"
  type        = string
  default     = "2"
}

variable "agw_max_capacity" {
  description = "Application Gateway auto scale capacity maximum"
  type        = string
  default     = "15"
}

variable "agw_availability_zone_count" {
  description = "The number of availability zones you want to deploy to"
  type        = list(string)
  default     = ["1", "2", "3"] # If you want use more then two availability zones set ["1", "2", "3"]
}

variable "agw_cookie_affinity" {
  description = "Enable Cookie-Based Affinity for backend"
  type        = bool
  default     = false
}

variable "agw_backend_address_pool" {
  description = "Backend Address Pool"
  type = list(object({
    name = string
    be_target_ips = list(string)
    be_target_fqdns        = list(string)
  }))
  default = [
    {
      name = "appGatewayBackendPool01"
      be_target_fqdns = [
        "jfdemoapp01.azurewebsites.net"
      ]
      be_target_ips = null
    },
    {
      name = "appGatewayBackendPool02"
      be_target_fqdns = [
        "jfdemoapp02.azurewebsites.net"
      ]
      be_target_ips = null
    }
  ]
}

variable "agw_backend_http_settings" {
  description = "Backend HTTP settings for the Application Gateway"
  type = list(object({
    name                                = string
    host_name                           = string
    cookie_based_affinity               = string
    affinity_cookie_name                = string
    port                                = number
    protocol                            = string
    request_timeout                     = number
    probe_name                          = string
    pick_host_name_from_backend_address = bool
    connection_draining_enabled         = bool
    connection_draining_timeout_sec     = number
  }))
  default = [
    {
      name                                = "appGatewayBackendHttpSettings-Site01"
      host_name                           = "jfdemoapp01.azurewebsites.net"
      cookie_based_affinity               = "Disabled"
      affinity_cookie_name                = null #"StickyApplicationGateway"
      port                                = 443
      protocol                            = "Https"
      request_timeout                     = 200
      probe_name                          = null
      pick_host_name_from_backend_address = false
      connection_draining_enabled         = false
      connection_draining_timeout_sec     = 180
    },
    {
      name                                = "appGatewayBackendHttpSettings-Site02"
      host_name                           = "jfdemoapp02.azurewebsites.net"
      cookie_based_affinity               = "Disabled"
      affinity_cookie_name                = null #"StickyApplicationGateway"
      port                                = 443
      protocol                            = "Https"
      request_timeout                     = 200
      probe_name                          = null
      pick_host_name_from_backend_address = false
      connection_draining_enabled         = false
      connection_draining_timeout_sec     = 180
    }
  ]
}

variable "agw_use_vm_targets" {
  description = "Use VMs for backend pool targets"
  type        = bool
  default     = false
}

#### App Gateway SSL Config
variable "ssl_policy" {
  description = "Defines the SSL Policy for the Application Gateway listeners"
  type = list(object({
    policy_type          = string
    min_protocol_version = string
    cipher_suites        = list(string)
    policy_name          = string
  }))
  default = [
    {
      policy_type          = "Predefined"
      min_protocol_version = null
      cipher_suites        = null
      policy_name          = "AppGwSslPolicy20220101"
    }
  ]
}

variable "agw_ssl_certificate" {
  description = "Name of SSL Certificate in the Key Vault"
  type        = string
  default     = "DemoCert"
}

variable "frontend_ip_configuration" {
  description = "Frontend IP Configuration"
  type = object({
    name                          = string
    subnet_id                     = string
    private_ip_address            = string
    private_ip_address_allocation = string
  })
  default = {
    name                          = "private"
    subnet_id                     = "/subscriptions/subscription-id/resourceGroups/jf-lab/providers/Microsoft.Network/virtualNetworks/vnet01/subnets/AGW"
    private_ip_address            = "10.0.2.200"
    private_ip_address_allocation = "Static"
  }
}

variable "frontend_port_name_HTTP" {
  description = "Frontend Port for HTTP"
  type        = string
  default     = "port80"
}

variable "frontend_port_name_HTTPS" {
  description = "Frontend Port for HTTPS"
  type        = string
  default     = "port443"
}

variable "gateway_ip_configuration_name" {
  description = "Gateway IP Configuration"
  type        = string
  default     = "appGatewayIpConfig"
}



#### App Gateway Listner Config
variable "agw_listeners" {
  description = "Defines listeners for Application Gateway"
  type = list(object({
    name                           = string
    frontend_ip_configuration_name = string
    frontend_port_name             = string
    protocol                       = string
    ssl_certificate_name           = string
    fqdn                           = string
    require_sni                    = bool
  }))
  default = [
    # {
    #   name                           = "HttpsListener"
    #   frontend_ip_configuration_name = "private"
    #   frontend_port_name             = "port80"
    #   protocol                       = "Http"
    #   ssl_certificate_name           = null # "DemoCert"
    #   fqdn                           = null
    #   require_sni                    = false
    #   },
      {
        name                           = "Site1-Listener"
        frontend_ip_configuration_name = "private"
        frontend_port_name             = "port80"
        protocol                       = "Http"
        ssl_certificate_name           = null
        fqdn                           = "jfdemoapp01.azurewebsites.net"
        require_sni                    = false
    },
    {
        name                           = "Site2-Listener"
        frontend_ip_configuration_name = "private"
        frontend_port_name             = "port80"
        protocol                       = "Http"
        ssl_certificate_name           = null
        fqdn                           = "jfdemoapp02.azurewebsites.net"
        require_sni                    = false
    }
  ]
}

#### App Gateway Routing/Redirect Config
variable "agw_routing_rules_http" {
  description = "Routing rules to define the application gateway"
  type = list(object({
    name                        = string
    priority                    = number
    rule_type                   = string
    http_listener_name          = string
    backend_http_settings_name  = string
    redirect_configuration_name = string

  }))
  default = [
    # {
    #   name                        = "redirectHttptoHttps"
    #   priority                    = 100
    #   rule_type                   = "Basic"
    #   http_listener_name          = "HttpListener"
    #   backend_address_pool_name   = null
    #   backend_http_settings_name  = null
    #   redirect_configuration_name = "redirectHttptoHttps"
    # }
  ]
}

variable "agw_routing_rules_https" {
  description = "Routing rules to define the application gateway"
  type = list(object({
    name                        = string
    priority                    = number
    rule_type                   = string
    http_listener_name          = string
    backend_address_pool_name   = string
    backend_http_settings_name  = string
    redirect_configuration_name = string

  }))
  default = [
    {
      name                        = "rule01"
      priority                    = 200
      rule_type                   = "Basic"
      http_listener_name          = "Site1-Listener"
      backend_address_pool_name   = "appGatewayBackendPool01"
      backend_http_settings_name  = "appGatewayBackendHttpSettings-Site01"
      redirect_configuration_name = null
    },
    {
      name                        = "rule02"
      priority                    = 201
      rule_type                   = "Basic"
      http_listener_name          = "Site2-Listener"
      backend_address_pool_name   = "appGatewayBackendPool02"
      backend_http_settings_name  = "appGatewayBackendHttpSettings-Site02"
      redirect_configuration_name = null
    }
  ]
}

variable "agw_enable_redirect" {
  description = "Enable 80 to 443 redirect"
  type        = bool
  default     = true
}

variable "agw_redirect_config" {
  description = "Redirect Configuration used for routing rules"
  type = list(object({
    name                 = string
    redirect_type        = string
    target_listener_name = string
    include_query_string = bool
    include_path         = bool
  }))
  default = [
    # {
    #   name                 = "redirectHttptoHttps"
    #   redirect_type        = "Permanent"
    #   target_listener_name = "HttpsListener"
    #   include_query_string = true
    #   include_path         = true
    # }
  ]
}

#### Application Gateway Health Probe Variables
variable "agw_health_probe" {
  description = "Application Gateway Data"
  type = list(object({
    probe_name                                      = string
    probe_protocol                                  = string
    probe_path                                      = string
    probe_interval                                  = number
    probe_timeout                                   = number
    probe_unhealthy_threshold                       = number
    probe_minimum_servers                           = string
    probe_match_body                                = string
    probe_status_code                               = list(string)
    probe_host                                      = string
    probe_pick_host_name_from_backend_http_settings = bool
  }))
  default = [
    # {
    #   probe_name                                      = "probe01"
    #   probe_protocol                                  = "Https"
    #   probe_path                                      = "/"
    #   probe_interval                                  = 15
    #   probe_timeout                                   = 15
    #   probe_unhealthy_threshold                       = 3
    #   probe_minimum_servers                           = "0"
    #   probe_match_body                                = ""
    #   probe_status_code                               = ["200-399"]
    #   probe_host                                      = "test.com"
    #   probe_pick_host_name_from_backend_http_settings = false
    # },
  ]
}