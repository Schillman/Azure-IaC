terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.42.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = var.management_subscription_id
  use_oidc        = true
  features {}
}

data "azurerm_client_config" "current" {}

module "prepare_governance" {
  source = "../../modules/terraform-azurerm-es-governance-preparation"

  resource_group_name          = var.management_resource_group_name
  log_analytics_workspace_name = var.management_log_analytics_workspace_name
  automation_account_name      = var.management_automation_account_name

  location = var.location
  tags     = var.tags
  settings = var.settings
}

resource "azurerm_key_vault" "keyvault" {
  for_each = var.key_vaults

  name                       = each.key
  location                   = module.prepare_governance.mgmt_rg.location
  resource_group_name        = module.prepare_governance.mgmt_rg.name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  public_network_access_enabled = true
  enabled_for_disk_encryption   = true
  enable_rbac_authorization     = true
  purge_protection_enabled      = true

  network_acls {
    default_action = "Deny"
    bypass         = "AzureServices"
    ip_rules       = [var.public_ip]
  }
}

resource "azurerm_role_assignment" "kv_access" {
  for_each = { for role in local.role_assignments : "${role.kv_name}_${role.role_name}_${role.p_id}" => role }

  scope                = azurerm_key_vault.keyvault[each.value.kv_name].id
  role_definition_name = each.value.role_name
  principal_id         = each.value.p_id
}

resource "azurerm_key_vault_secret" "kv_secret" {
  for_each = { for kv in local.secrets : "${kv.kv_name}_${kv.name}" => kv }

  name         = each.value.name
  value        = each.value.value
  key_vault_id = azurerm_key_vault.keyvault[each.value.kv_name].id

  lifecycle {
    ignore_changes = [
      name
    ]
  }

  depends_on = [
    azurerm_role_assignment.kv_access
  ]
}

resource "azurerm_resource_group" "tmp" {
  name     = "Temp-rg"
  location = var.location
}
