resource "azurerm_resource_group" "mgmt" {

  name     = local.mgmt_resource_group_name
  location = local.location
  tags     = try(local.tags, null)
}

resource "azurerm_log_analytics_workspace" "mgmt" {

  # Mandatory resource attributes
  name                = local.mgmt_log_analytics_workspace_name
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name

  # Optional resource settings
  sku                        = local.settings.log_analytics_workspace.sku
  retention_in_days          = local.settings.log_analytics_workspace.retention_in_days
  internet_ingestion_enabled = local.settings.log_analytics_workspace.internet_ingestion_enabled
  internet_query_enabled     = local.settings.log_analytics_workspace.internet_query_enabled
  tags                       = try(local.tags, null)
}

resource "azurerm_automation_account" "mgmt" {

  # Mandatory resource attributes
  name                = local.mgmt_automation_account_name
  location            = azurerm_resource_group.mgmt.location
  resource_group_name = azurerm_resource_group.mgmt.name

  # Optional resource attributes
  sku_name = local.settings.automation_account.sku_name
  tags     = try(local.tags, null)

  identity {
    type = "SystemAssigned"
  }
}
