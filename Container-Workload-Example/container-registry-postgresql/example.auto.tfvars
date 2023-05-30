# vars.tfvars

resource_group = {
  name     = "my-resource-group"
  location = "eastus"
}

tags = {
  BusinessUnit = "ToBeDefined"
  environment  = "dev"
  costcenter   = "it"
}

acr-mananged-identity = "mi-acr-example"

container_registry = {
  name                          = "pgexampleacr"
  sku                           = "Premium"
  admin_enabled                 = true
  public_network_access_enabled = false
  georeplication                = []
  vnet_name                     = "my-vnet"
  vnet_rg_name                  = "vnet-resource-group"
  subnet_name                   = "acr-subnet"
  private_dns_zone_name         = "privatelink.azurecr.io"
  private_dns_zone_rg_name      = "vnet-resource-group"
}

postgresql_server = {
  name                           = "pg-example-server-name"
  version                        = "13"
  sku_name                       = "GP_Standard_D2s_v3"
  storage_mb                     = 32768
  zone                           = "1"
  admin_secret_name              = "pgadmin"
  admin_secret_key_vault_name    = "pg-example-vault"
  admin_secret_key_vault_rg_name = "vnet-resource-group"
  delegated_subnet_name          = "pg-subnet"
  delegated_vnet_name            = "my-vnet"
  delegated_vnet_rg_name         = "vnet-resource-group"
  private_dns_zone_name          = "pg.postgres.database.azure.com"
  private_dns_zone_rg_name       = "vnet-resource-group"

  authentication = {
    active_directory_auth_enabled     = true
    password_auth_enabled             = true
    active_directory_admin_group_name = "CoPilot-Owners"
  }
}

postgresql_server_firewall_rules = [
  {
    name             = "allow-all"
    start_ip_address = "10.1.0.0"
    end_ip_address   = "10.1.255.255"
  }
]

postgresql_database = {
  name      = "my-database"
  charset   = "UTF8"
  collation = "en_US.utf8"
}