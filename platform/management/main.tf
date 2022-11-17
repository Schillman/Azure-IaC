terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 2.77.0"
    }
  }
  backend "azurerm" {}
}

provider "azurerm" {
  subscription_id = var.management_subscription_id
  features {}
}

module "prepare_governance" {
  source = "../../modules/terraform-azurerm-es-governance-preparation"

  resource_group_name          = var.management_resource_group_name
  log_analytics_workspace_name = var.management_log_analytics_workspace_name
  automation_account_name      = var.management_automation_account_name

  location = var.location
  tags     = var.tags
  settings = var.settings
}
