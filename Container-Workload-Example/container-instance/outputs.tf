output "container_group_name" {
  value = azurerm_container_group.aci.name
}

output "container_group_ip_address" {
  value = azurerm_container_group.aci.ip_address
}

output "container_group_containers" {
  value = [for c in azurerm_container_group.aci.container : {
    name  = c.name
    image = c.image
    port  = c.ports
  }]
}
