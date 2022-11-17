# Convert the input vars to locals, applying any required
# logic needed before they are used in the module.
# No vars should be referenced elsewhere in the module.
locals {
  location                     = var.location
  solution_name                = format("%s-%s", var.default_solution_name, var.environment)
  rg_network_name              = format("network-%s-rg", var.environment)
  rg_name                      = format("%s-rg", local.solution_name)
  vnet_name                    = format("%s-vnet", local.solution_name)
  virtual_network_peering_name = format("%s-to-hub-peering", local.vnet_name)
}

locals {
  vnet_address_spaces       = var.vnet_address_spaces
  vnet_dns_servers          = var.vnet_dns_servers
  remote_virtual_network_id = var.remote_virtual_network_id
  peer_vnet                 = var.remote_virtual_network_id != null ? true : false
}

locals {
  subnets = {
    front-calc-snet = {
      subnet_address_prefixes                       = var.front_calc_snet_address_prefixes
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
      network_security_group_name                   = format("%s-front-calc-nsg", local.vnet_name)
      route_table_name                              = format("%s-front-calc-rt", local.vnet_name)
      disable_bgp_route_propagation                 = false
      security_rules                                = var.front_calc_nsg_security_rules
      routes                                        = var.front_calc_rt_routes
    },
    calc-nodes-snet = {
      subnet_address_prefixes                       = var.calc_nodes_snet_address_prefixes
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
      network_security_group_name                   = format("%s-calc-nodes-nsg", local.vnet_name)
      route_table_name                              = format("%s-calc-nodes-rt", local.vnet_name)
      disable_bgp_route_propagation                 = false
      security_rules                                = var.calc_nodes_nsg_security_rules
      routes                                        = var.calc_nodes_rt_routes
    },
    storage-snet = {
      subnet_address_prefixes                       = var.storage_snet_address_prefixes
      private_endpoint_network_policies_enabled     = true
      private_link_service_network_policies_enabled = true
      network_security_group_name                   = format("%s-storage-nsg", local.vnet_name)
      route_table_name                              = format("%s-storage-rt", local.vnet_name)
      disable_bgp_route_propagation                 = false
      security_rules                                = var.storage_nsg_security_rules
      routes                                        = var.storage_rt_routes
    },
    priv-ep-snet = {
      subnet_address_prefixes                       = var.priv_ep_snet_address_prefixes
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
      network_security_group_name                   = format("%s-priv-ep-nsg", local.vnet_name)
      route_table_name                              = format("%s-priv-ep-rt", local.vnet_name)
      disable_bgp_route_propagation                 = false
      security_rules                                = var.priv_ep_nsg_security_rules
      routes                                        = var.priv_ep_rt_routes
    },
    AzureBastionSubnet = {
      subnet_address_prefixes                       = var.bastion_snet_address_prefixes
      private_endpoint_network_policies_enabled     = false
      private_link_service_network_policies_enabled = false
      network_security_group_name                   = ""
      route_table_name                              = ""
      disable_bgp_route_propagation                 = false
      security_rules                                = {}
      routes                                        = []
    }
  }
}

# Default Values
locals {
  default_routes = [
    {
      name                   = "DefaultUDR-Vnet"
      address_prefix         = tostring(local.vnet_address_spaces[0])
      next_hop_type          = "VnetLocal"
      next_hop_in_ip_address = null
    },
    {
      name                   = "DefaultUDR-FW"
      address_prefix         = "0.0.0.0/0"
      next_hop_type          = "VirtualAppliance"
      next_hop_in_ip_address = "100.96.192.68"
    }
  ]

  default_security_rules = {
    name                       = ""
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

locals {
  security_rules = { for entry in local.subnets : entry.network_security_group_name => merge(entry.security_rules, local.default_security_rules)
    if entry.network_security_group_name != ""
  }

  custom_routes = {
    for entry in local.subnets : entry.route_table_name => {
      for r in entry.routes : r.name => merge(r, { route_table_name = entry.route_table_name })
    }
    if entry.route_table_name != ""
  }

  routes = {
    for entry in local.subnets : entry.route_table_name => {
      for dr in local.default_routes : dr.name => merge(dr, { route_table_name = entry.route_table_name })
    }
    if entry.route_table_name != ""
  }

  custom_routes_flatten = flatten([
    for rt_key, rt in local.custom_routes : [
      for route_key, route in rt : route
    ]
  ])

  routes_flatten = flatten([
    for rt_key, rt in local.routes : [
      for route_key, route in rt : route
    ]
  ])

  concat_routes = concat(local.custom_routes_flatten, local.routes_flatten)

  all_routes = { for route in local.concat_routes : "${route.route_table_name}_${route.name}" => route }
}