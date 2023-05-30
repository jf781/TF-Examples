variable "tags" {
  description = "Tags for the resources"
  type        = map(string)
}

variable "resourse_group_name" {
  description = "Resource group name"
  type        = string
}

variable "container_group" {
  description = "Azure Container Group configuration"
  type = object({
    name            = string
    ip_address_type = string
    dns_name_label  = string
    os_type         = string
    identity_type   = string
    identity_name   = string
    subnet_name     = string
    vnet_name       = string
    vnet_rg_name    = string

    containers = list(object({
      name                         = string
      image                        = string
      cpu                          = number
      memory                       = string
      environment_variables        = map(string)
      secure_environment_variables = map(string)
      port                         = number
      protocol                     = string
    }))
  })
}

variable "log_analytics_workspace" {
  description = "Log Analytics Workspace configuration"
  type = object({
    name    = string
    rg_name = string
  })
}

variable "container_registry" {
  description = "Container Registry configuration"
  type = object({
    name                = string
    resource_group_name = string
  })
}