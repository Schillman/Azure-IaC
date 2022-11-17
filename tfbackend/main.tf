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

data "azurerm_client_config" "core" {}

resource "azurerm_resource_group" "rg_tfbackend" {
  name     = var.rg_tfbackend
  location = var.location
  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_storage_account" "st_tfbackend" {
  name                             = var.st_tfbackend
  resource_group_name              = azurerm_resource_group.rg_tfbackend.name
  location                         = azurerm_resource_group.rg_tfbackend.location
  account_kind                     = "StorageV2"
  account_tier                     = "Standard"
  access_tier                      = "Hot"
  account_replication_type         = "ZRS"
  enable_https_traffic_only        = true
  min_tls_version                  = "TLS1_2"
  allow_nested_items_to_be_public  = false
  cross_tenant_replication_enabled = false

  lifecycle {
    prevent_destroy = true
  }
}

resource "azurerm_role_assignment" "spn_object_id" {
  count                = var.spn_object_id == "" ? 0 : 1
  scope                = azurerm_storage_account.st_tfbackend.id
  role_definition_name = "Contributor"
  principal_id         = var.spn_object_id
}

resource "azurerm_management_lock" "tfstatelock" {
  name       = "TFStateLock"
  scope      = azurerm_storage_account.st_tfbackend.id
  lock_level = "CanNotDelete"
  notes      = "Do not delete lock, storage account holding Terraform state files."
}

resource "azurerm_storage_container" "containers" {
  count                = length(var.containers)
  name                 = var.containers[count.index]
  storage_account_name = azurerm_storage_account.st_tfbackend.name
}
