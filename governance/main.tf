terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.98.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "core" {}

module "enterprise_scale" {
  source  = "Azure/caf-enterprise-scale/azurerm"
  version = "1.1.2"

  providers = {
    azurerm              = azurerm
    azurerm.connectivity = azurerm
    azurerm.management   = azurerm
  }

  root_parent_id = data.azurerm_client_config.core.tenant_id
  root_id        = var.root_id
  root_name      = var.root_name
  library_path   = "${path.root}/lib"

  # Management
  deploy_management_resources    = var.deploy_management_resources
  subscription_id_management     = var.management_subscription_id
  configure_management_resources = local.configure_management_resources

  /*
  # Identity
  deploy_identity_resources    = var.deploy_identity_resources
  subscription_id_identity     = var.identity_subscription_id
  configure_identity_resources = local.configure_identity_resources

  # Connectivity
  deploy_connectivity_resources = var.deploy_connectivity_resources
  subscription_id_connectivity  = var.connectivity_subscription_id
  # configure_connectivity_resources = local.configure_connectivity_resources

  # Override default settings
  # archetype_config_overrides = local.archetype_config_overrides

  # Landing Zones
  deploy_corp_landing_zones   = true
  deploy_online_landing_zones = true
 */
}
