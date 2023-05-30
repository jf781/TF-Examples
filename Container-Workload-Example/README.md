# Container Workload Example
This example has two workspaces that are deployed independently of each other. The first workspace deploys a container registry and PostgresSQL server and the second workspace deploys a containerized application that utilizes the container registry.

## Prerequisites
- Vnet and subnets created
  - The subnet for PostgresSQL must have:
    - Be a dedicated subnet for PostgresSQL [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/postgresql/flexible-server/concepts-networking/)
    - The `Microsoft.Storage` service endpoint enabled 
    - Delegated to `Microsoft.DBforPostgreSQL/flexibleServers`
  - The subnet for the ACR must have:
    - The `Microsoft.ContainerRegistry` service endpoint enabled
  - The subnet for ACI must have:
    - Be a dedicated subnet for Azure Container Instance [Microsoft Documentation](https://learn.microsoft.com/en-us/azure/container-instances/container-instances-virtual-network-concepts#subnet-delegated)
    - Delegated to `Microsoft.ContainerInstance/containerGroups`
- Log Analytics Workspace
- Key Vault for PostgresSQL credentials
- Private DNS zone for `postgres.database.azure.com`

## Utilizing Private Networking
The examples show the ability to deploy the resources using a private network as the default option rather then having the resources available.  This is done through a combination of associating the resources with a subnet and using Private Endpoints
