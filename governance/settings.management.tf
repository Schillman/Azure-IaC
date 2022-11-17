data "azurerm_resource_group" "mgmt_rg" {
  name = var.management_resource_group_name
}

data "azurerm_log_analytics_workspace" "mgmt_log" {
  name                = var.management_log_analytics_workspace_name
  resource_group_name = var.management_resource_group_name
}

data "azurerm_automation_account" "mgmt_aa" {
  name                = var.management_automation_account_name
  resource_group_name = var.management_resource_group_name
}

locals {
  configure_management_resources = {
    settings = {
      log_analytics = {
        enabled = true
        config = {
          retention_in_days                           = var.log_retention_in_days
          enable_monitoring_for_arc                   = true
          enable_monitoring_for_vm                    = true
          enable_monitoring_for_vmss                  = true
          enable_solution_for_agent_health_assessment = true
          enable_solution_for_anti_malware            = true
          enable_solution_for_azure_activity          = true
          enable_solution_for_change_tracking         = true
          enable_solution_for_service_map             = true
          enable_solution_for_sql_assessment          = true
          enable_solution_for_updates                 = true
          enable_solution_for_vm_insights             = true
          enable_sentinel                             = true
        }
      }
      security_center = {
        enabled = true
        config = {
          email_security_contact             = var.security_alerts_email_address
          enable_defender_for_acr            = true
          enable_defender_for_app_services   = true
          enable_defender_for_arm            = true
          enable_defender_for_dns            = true
          enable_defender_for_key_vault      = true
          enable_defender_for_kubernetes     = true
          enable_defender_for_oss_databases  = true
          enable_defender_for_servers        = true
          enable_defender_for_sql_servers    = true
          enable_defender_for_sql_server_vms = true
          enable_defender_for_storage        = true
        }
      }
    }

    location = var.location
    tags     = var.tags

    advanced = {
      existing_resource_group_name                 = data.azurerm_resource_group.mgmt_rg.name
      existing_log_analytics_workspace_resource_id = data.azurerm_log_analytics_workspace.mgmt_log.id
      existing_automation_account_resource_id      = data.azurerm_automation_account.mgmt_aa.id
      custom_settings_by_resource_type = {
        azurerm_log_analytics_workspace = {
          management = {
            name = data.azurerm_log_analytics_workspace.mgmt_log.name
          }
        }
        azurerm_automation_account = {
          management = {
            name = data.azurerm_automation_account.mgmt_aa.name
          }
        }
      }
    }
  }
}
