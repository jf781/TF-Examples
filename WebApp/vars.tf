variable "resource_group" {
  description = "Configuration for the Azure Resource Group."
  type = object({
    name     = string
    location = string
  })
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to resources."
  default     = {}
}

variable "app_service_plan" {
  description = "Configuration for the Azure App Service Plan."
  type = object({
    name     = string
    os_type  = string
    sku_name = string
  })
}

variable "app_service" {
  description = "Configuration for the Azure App Service."
  type = object({
    name = string
    site_settings = object({
      worker_count  = number
      always_on     = bool
      http2_enabled = bool
    })
    application_stack = object({
      docker_image_name   = string
      docker_registry_url = string
    })
  })
}
