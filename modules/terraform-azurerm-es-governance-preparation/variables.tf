variable "resource_group_name" {
  type        = string
  description = "Name for creating management Resource Group to store necessary resources."
  default     = ""
}

variable "log_analytics_workspace_name" {
  type        = string
  description = "Name for creating Log Analytics workspace."
  default     = ""
}

variable "automation_account_name" {
  type        = string
  description = "Name for creating Automation Account."
  default     = ""
}

variable "location" {
  type        = string
  description = "Sets the default location used for resource deployments where needed."
  default     = "westeurope"
}

variable "tags" {
  type        = map(string)
  description = "If specified, will set the default tags for all resources deployed by this module where supported."
  default     = {}
}

variable "settings" {
  type = object({
    log_analytics_workspace = object({
      sku                        = any
      retention_in_days          = any
      internet_ingestion_enabled = any
      internet_query_enabled     = any
    })
    automation_account = object({
      sku_name = any
    })
  })
  description = "resource settings for preparing the \"Management\" landing zone."
}
