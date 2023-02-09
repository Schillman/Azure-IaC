resource "azurerm_resource_group" "network" {
  name     = local.rg_network_name
  location = local.location
}

resource "azurerm_virtual_network" "network" {
  name                = local.vnet_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
  address_space       = local.vnet_address_spaces
  dns_servers         = local.vnet_dns_servers

  tags = {
    cf-vnet-peerable = local.peer_vnet
    serviceID        = "1234"
  }
}

resource "azurerm_virtual_network_peering" "network" {
  count = local.peer_vnet != true ? 0 : 1

  name                      = local.virtual_network_peering_name
  resource_group_name       = azurerm_resource_group.network.name
  virtual_network_name      = azurerm_virtual_network.network.name
  remote_virtual_network_id = local.remote_virtual_network_id
}

resource "azurerm_subnet" "network" {
  for_each = local.subnets

  name                 = each.key
  resource_group_name  = azurerm_resource_group.network.name
  virtual_network_name = azurerm_virtual_network.network.name
  address_prefixes     = [each.value.subnet_address_prefixes]

  private_endpoint_network_policies_enabled     = each.value.private_endpoint_network_policies_enabled
  private_link_service_network_policies_enabled = each.value.private_link_service_network_policies_enabled
}

resource "azurerm_network_security_group" "network" {
  for_each = { for subnet in local.subnets : subnet.network_security_group_name => subnet
    if subnet.network_security_group_name != ""
  }

  name                = each.value.network_security_group_name
  location            = azurerm_resource_group.network.location
  resource_group_name = azurerm_resource_group.network.name
}

resource "azurerm_network_security_rule" "network" {
  for_each = { for rule in local.security_rules : rule.name => rule
    if rule.name != ""
  }

  name                        = each.value.name
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.network.name
  network_security_group_name = each.key

  depends_on = [
    azurerm_network_security_group.network
  ]
}


resource "azurerm_route_table" "network" {
  for_each = { for subnet in local.subnets : subnet.route_table_name => subnet
    if subnet.route_table_name != ""
  }

  name                          = each.value.route_table_name
  location                      = azurerm_resource_group.network.location
  resource_group_name           = azurerm_resource_group.network.name
  disable_bgp_route_propagation = each.value.disable_bgp_route_propagation

  depends_on = [
    azurerm_subnet.network
  ]
}

resource "azurerm_route" "network" {
  for_each = local.all_routes

  name                   = each.value.name
  resource_group_name    = azurerm_resource_group.network.name
  route_table_name       = each.value.route_table_name
  address_prefix         = each.value.address_prefix
  next_hop_type          = each.value.next_hop_type
  next_hop_in_ip_address = each.value.next_hop_in_ip_address

  depends_on = [
    azurerm_route_table.network
  ]
}

resource "azurerm_subnet_network_security_group_association" "network" {
  for_each = { for subnet in azurerm_subnet.network : subnet.name => subnet
    if subnet.name != "AzureBastionSubnet"
  }

  subnet_id                 = each.value.id
  network_security_group_id = azurerm_network_security_group.network[lookup(local.subnets, each.value.name, null).network_security_group_name].id
}

resource "azurerm_subnet_route_table_association" "network" {
  for_each = { for subnet in azurerm_subnet.network : subnet.name => subnet
    if subnet.name != "AzureBastionSubnet"
  }

  subnet_id      = each.value.id
  route_table_id = azurerm_route_table.network[lookup(local.subnets, each.value.name, null).route_table_name].id
}
