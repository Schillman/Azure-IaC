terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
    }
  }
}

provider "azurerm" {
  disable_terraform_partner_id = true

  features {}
}

module "network" {
  source = "../"

  default_solution_name = "solution"
  environment           = "tst"
  location              = "West Europe"
  vnet_address_spaces = [
    "xx.x6.19.0/24"
  ]
  vnet_dns_servers = [
    "xx.x.254.30"
  ]
  # remote_virtual_network_id    = var.remote_virtual_network_id # will peer network to hub if specified

  front_calc_snet_address_prefixes = "xx.x6.19.160/28"
  front_calc_rt_routes             = []
  front_calc_nsg_security_rules    = {}

  calc_nodes_snet_address_prefixes = "xx.x6.19.0/26"
  calc_nodes_rt_routes             = []
  calc_nodes_nsg_security_rules    = {}

  storage_snet_address_prefixes = "xx.x6.19.176/28"
  storage_rt_routes             = []
  storage_nsg_security_rules    = {}

  priv_ep_snet_address_prefixes = "xx.x6.19.128/27"
  priv_ep_rt_routes             = []
  priv_ep_nsg_security_rules    = {}

  bastion_snet_address_prefixes = "xx.x6.19.64/26"
}

