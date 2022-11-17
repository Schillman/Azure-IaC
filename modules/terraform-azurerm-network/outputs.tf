output "network_resource_group_name" {
  value = azurerm_resource_group.network.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.network.name
}

output "calc_subnet_name" {
  value = azurerm_subnet.network["calc-nodes-snet"].name
}

output "head_subnet_id" {
  value = azurerm_subnet.network["calc-nodes-snet"].id
}

output "calc_nsg_id" {
  value = azurerm_network_security_group.network["numerix-tst-vnet-calc-nodes-nsg"].id
}

