data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "runner" {
  name                       = "githubactionskeyvaultgg"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "standard"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "create",
      "get",
    ]

    secret_permissions = [
      "set",
      "list",
      "get",
      "delete",
      "purge",
      "recover"
    ]
  }
}


resource "azurerm_log_analytics_workspace" "kvlogs" {
  name                = "kv-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "kv" {
  name                        = "kv-diagnostics"
  target_resource_id          = azurerm_key_vault.runner.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.kvlogs.id

  log {
    category = "AuditEvent"
    enabled  = true
  }
}


