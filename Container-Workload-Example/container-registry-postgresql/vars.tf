# vars.tf

variable "resource_group" {
  description = "Resource group configuration"
  type = object({
    name     = string
    location = string
  })
}

variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}

variable "container_registry" {
  description = "Container registry configuration"
  type = object({
    name                          = string
    sku                           = string
    admin_enabled                 = bool
    public_network_access_enabled = bool
    vnet_name                     = string
    vnet_rg_name                  = string
    subnet_name                   = string
    private_dns_zone_name         = string
    private_dns_zone_rg_name      = string
    georeplication = list(object({
      name            = string
      zone_redundancy = bool
      tags            = map(string)
    }))
  })
}

variable "acr-mananged-identity" {
  description = "Name of managed identity"
  type        = string
}

variable "postgresql_server" {
  description = "PostgreSQL server configuration"
  type = object({
    name                           = string
    version                        = string
    sku_name                       = string
    storage_mb                     = number
    zone                           = string
    delegated_subnet_name          = string
    delegated_vnet_name            = string
    delegated_vnet_rg_name         = string
    private_dns_zone_name          = string
    private_dns_zone_rg_name       = string
    admin_secret_name              = string
    admin_secret_key_vault_name    = string
    admin_secret_key_vault_rg_name = string

    authentication = object({
      active_directory_auth_enabled     = bool
      password_auth_enabled             = bool
      active_directory_admin_group_name = string
    })
  })
}

variable "postgresql_server_firewall_rules" {
  description = "PostgreSQL server firewall rules"
  type = list(object({
    name             = string
    start_ip_address = string
    end_ip_address   = string
  }))
}

variable "postgresql_database" {
  description = "PostgreSQL database configuration"
  type = object({
    name      = string
    charset   = string
    collation = string
  })
}