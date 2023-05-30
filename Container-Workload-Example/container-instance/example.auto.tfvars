resourse_group_name = "my-resource-group"

tags = {
  BusinessUnit = "ToBeDefined"
  environment  = "dev"
  costcenter   = "it"
}

container_group = {
  name            = "my-container-group"
  ip_address_type = "Private"
  dns_name_label  = "my-container-group-dns"
  os_type         = "Linux"
  identity_name   = "mi-acr"
  identity_type   = "UserAssigned"
  subnet_name     = "aci-subnet"
  vnet_name       = "my-vnet"
  vnet_rg_name    = "vnet-resource-group"

  containers = [
    {
      name   = "container-1"
      image  = "nginx:latest"
      cpu    = 1
      memory = ".5"
      environment_variables = {
        ENV_VAR1 = "value1"
        ENV_VAR2 = "value2"
      }
      secure_environment_variables = {
        SECRET_VAR1 = "secret_value1"
        SECRET_VAR2 = "secret_value2"
      }
      port     = 80
      protocol = "TCP"
      },
      {
        name   = "container-2"
        image  = "mysql:latest"
        cpu    = 2
        memory = "1"
        environment_variables = {
          MYSQL_ROOT_PASSWORD = "my_password"
        }
        secure_environment_variables = {}
        port                         = 3306
        protocol                     = "TCP"
    }
  ]
}

container_registry = {
  name                = "pgexampleacr"
  resource_group_name = "my-resource-group"
}

log_analytics_workspace = {
  name    = "my-log-analytics-workspace"
  rg_name = "vnet-resource-group"
}
