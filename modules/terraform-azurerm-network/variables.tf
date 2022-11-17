variable "location" {
  type        = string
  description = "The Azure Region where the Resource Group should exist. Changing this forces a new Resource Group to be created."
}

variable "environment" {
  type        = string
  description = "dev, tst or prd"
}

variable "default_solution_name" {
  type        = string
  description = "Name for solution, will be used when creating resourses"

}

variable "vnet_address_spaces" {
  type        = list(string)
  description = "(Required) The address space that is used the virtual network. You can supply more than one address space."
}

variable "vnet_dns_servers" {
  type        = list(string)
  description = "List of IP addresses of DNS servers"
}

variable "remote_virtual_network_id" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network. Changing this forces a new resource to be created."
  default     = null
}

variable "front_calc_snet_address_prefixes" {
  type        = string
  description = "subnet prefix for head node subnet"
}

variable "calc_nodes_snet_address_prefixes" {
  type        = string
  description = "subnet prefix for worker node subnet"
}

variable "storage_snet_address_prefixes" {
  type        = string
  description = "subnet prefix for storage subnet"
}

variable "priv_ep_snet_address_prefixes" {
  type        = string
  description = "subnet prefix for private endpoint subnet"
}

variable "bastion_snet_address_prefixes" {
  type        = string
  description = "subnet prefix for bastion subnet"
}

variable "front_calc_nsg_security_rules" {
  type        = map(any)
  description = "subnet prefix for head node subnet"
  default     = {}
}

variable "calc_nodes_nsg_security_rules" {
  type        = map(any)
  description = "subnet prefix for worker node subnet"
  default     = {}
}

variable "storage_nsg_security_rules" {
  type        = map(any)
  description = "subnet prefix for storage subnet"
  default     = {}
}

variable "priv_ep_nsg_security_rules" {
  type        = map(any)
  description = "subnet prefix for private endpoint subnet"
  default     = {}
}

variable "front_calc_rt_routes" {
  type        = list(any)
  description = "routes for head node subnet"
  default     = []
}

variable "calc_nodes_rt_routes" {
  type        = list(any)
  description = "routes for worker node subnet"
  default     = []
}

variable "storage_rt_routes" {
  type        = list(any)
  description = "routes for storage subnet"
  default     = []
}

variable "priv_ep_rt_routes" {
  type        = list(any)
  description = "routes for private endpoint subnet"
  default     = []
}
