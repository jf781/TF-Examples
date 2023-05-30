# Define an Azure Container Group
resource "azurerm_container_group" "aci" {
  name                = var.container_group.name
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = data.azurerm_resource_group.rg.location
  ip_address_type     = var.container_group.ip_address_type
  # dns_name_label      = var.container_group.dns_name_label
  os_type    = var.container_group.os_type
  subnet_ids = [data.azurerm_subnet.subnet.id]
  tags       = var.tags

  # identity {
  #   type = var.container_group.identity_type
  #   identity_ids = [data.azurerm_user_assigned_identity.mi.id]
  # }

  dynamic "container" {
    for_each = var.container_group.containers
    content {
      name                         = container.value.name
      image                        = container.value.image
      cpu                          = container.value.cpu
      memory                       = container.value.memory
      environment_variables        = container.value.environment_variables
      secure_environment_variables = container.value.secure_environment_variables

      ports {
        port     = container.value.port
        protocol = container.value.protocol
      }
    }
  }

  diagnostics {
    log_analytics {
      workspace_id  = data.azurerm_log_analytics_workspace.laws.workspace_id
      workspace_key = data.azurerm_log_analytics_workspace.laws.primary_shared_key
    }
  }
}
