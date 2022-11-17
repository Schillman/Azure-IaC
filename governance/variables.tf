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
variable "deploy_management_resources" {
  type    = bool
  default = false
}

variable "management_subscription_id" {
  type    = string
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

variable "log_retention_in_days" {
  type    = number
  default = 30
}

variable "security_alerts_email_address" {
  type    = string
}
