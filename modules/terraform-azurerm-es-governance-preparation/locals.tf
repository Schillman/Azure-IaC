# Convert the input vars to locals, applying any required
# logic needed before they are used in the module.
# variables should not exist anywhere else in the module.
locals {
  mgmt_resource_group_name          = coalesce(var.resource_group_name, "rg-platform")
  mgmt_log_analytics_workspace_name = coalesce(var.log_analytics_workspace_name, "log-platform")
  mgmt_automation_account_name      = coalesce(var.automation_account_name, "aa-platform")

  location = var.location
  tags     = var.tags
}

# Extract individual optional settings blocks from
# the settings variable.
locals {
  settings = {
    log_analytics_workspace = {
      sku                        = coalesce(var.settings.log_analytics_workspace.sku, "PerGB2018")
      retention_in_days          = coalesce(var.settings.log_analytics_workspace.retention_in_days, 30)
      internet_ingestion_enabled = coalesce(var.settings.log_analytics_workspace.internet_ingestion_enabled, true)
      internet_query_enabled     = coalesce(var.settings.log_analytics_workspace.internet_query_enabled, true)
    }
    automation_account = {
      sku_name = coalesce(var.settings.automation_account.sku_name, "Basic")
    }
  }
}

# Configuration settings for resource type:
#  - azurerm_resource_group
locals {
  resource_group_name = local.mgmt_resource_group_name
  azurerm_resource_group = {
    name     = local.resource_group_name,
    location = local.location
    tags     = local.tags
  }
}

# Configuration settings for resource type:
#  - azurerm_log_analytics_workspace
locals {
  azurerm_log_analytics_workspace = {
    name                       = local.mgmt_log_analytics_workspace_name
    location                   = local.location
    sku                        = local.settings.log_analytics_workspace.sku
    retention_in_days          = local.settings.log_analytics_workspace.retention_in_days
    internet_ingestion_enabled = local.settings.log_analytics_workspace.internet_ingestion_enabled
    internet_query_enabled     = local.settings.log_analytics_workspace.internet_query_enabled
    tags                       = local.tags
    resource_group_name        = local.resource_group_name
  }
}

# Configuration settings for resource type:
#  - azurerm_automation_account
locals {
  azurerm_automation_account = {
    name                = local.mgmt_automation_account_name
    location            = local.location
    sku_name            = local.settings.automation_account.sku_name
    tags                = local.tags
    resource_group_name = local.resource_group_name
  }
}
