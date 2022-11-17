variable "root_id" {
  type    = string
  default = "es"
}

variable "root_name" {
  type    = string
  default = "Schillman Group"
}

variable "location" {
  type    = string
  default = "swedencentral"
}

variable "tags" {
  type    = map(string)
  default = {}
}

# Management variables
variable "management_subscription_id" {
  type = string
}

variable "management_resource_group_name" {
  type    = string
  default = "rg-platform"
}

variable "management_log_analytics_workspace_name" {
  type    = string
  default = "log-platform"
}

variable "management_automation_account_name" {
  type    = string
  default = "aa-platform"
}

variable "notification_email" {
  type = string
}

variable "settings" {
  type = any
  default = {
    log_analytics_workspace = {
      sku                        = null
      retention_in_days          = null
      internet_ingestion_enabled = null
      internet_query_enabled     = null
    }
    automation_account = {
      sku_name = null
    }
  }
  description = "resource settings for preparing the \"Management\" landing zone."
}

# DNS Zones
variable "dns_zone_name" {
  type        = string
  description = "(Required) The name of the DNS Zone. Must be a valid domain name."
}

variable "mx_record" {
  type        = string
  description = "(Required) The mail server responsible for the domain covered by the MX record."
}

variable "dns_cname_record" {
  description = "Object to enable DNS CNAME Records within Azure DNS."
  type = map(object({
    record = string
  }))
}
