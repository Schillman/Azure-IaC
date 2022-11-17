output "mgmt_rg" {
  value = azurerm_resource_group.mgmt
}

output "mgmt_log" {
  value = azurerm_log_analytics_workspace.mgmt
}

output "mgmt_aa" {
  value = azurerm_automation_account.mgmt
}

output "aa_managed_identity" {
  value = azurerm_automation_account.mgmt.identity.0.principal_id
}
