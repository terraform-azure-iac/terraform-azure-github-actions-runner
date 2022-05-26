
# Automation account with pwsh runbook to send notifications.
# The webhook receiver configuration in action group does not work for some 
# communication platforms such as Slack

resource "azurerm_automation_account" "automation_account" {
    name                = var.automation_account_name
    location            = var.location
    resource_group_name = var.resource_group_name

    sku_name = "Basic"
}

data "template_file" "rb" {
    template = "${file("${path.module}/scripts/runbook.ps1")}"
    vars = {
      webhook_url = var.webhook_link
    }
}

resource "azurerm_automation_runbook" "runbook" {
    name                    = var.runbook_name
    location                = var.location
    resource_group_name     = var.resource_group_name
    automation_account_name = azurerm_automation_account.automation_account.name
    log_verbose             = "true"
    log_progress            = "true"
    description             = "Webhook pwsh script"
    runbook_type            = "PowerShell"
    content                 = data.template_file.rb.template
}

resource "azurerm_automation_webhook" "rb_wh" {
  name                    = "${var.runbook_name}-webhook"
  resource_group_name     = var.resource_group_name
  automation_account_name = azurerm_automation_account.automation_account.name
  expiry_time             = "2022-12-31T00:00:00Z"
  enabled                 = true
  runbook_name            = azurerm_automation_runbook.runbook.name
}

resource "azurerm_monitor_action_group" "main" {
  name                = "alerts"
  resource_group_name = var.resource_group_name
  short_name          = "alerts"

  email_receiver {
    name                    = "AlertReceivers"
    email_address           = "test@test.com"
    use_common_alert_schema = true
  }

  automation_runbook_receiver {
    name                    = "webhook"
    automation_account_id   = azurerm_automation_account.automation_account.id
    runbook_name            = azurerm_automation_runbook.runbook.name
    webhook_resource_id     = azurerm_automation_runbook.runbook.id
    is_global_runbook       = false
    service_uri             = azurerm_automation_webhook.rb_wh.uri
    use_common_alert_schema = true
  }
}

# -------------------- VM monitoring --------------------

resource "azurerm_monitor_metric_alert" "cpu-alert" {
  name                = "${var.vm_name}-CPU-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vm_id]
  description         = "Triggers when CPU usage is over .. for .. min"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = 80
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

resource "azurerm_monitor_metric_alert" "ram-alert" {
  name                = "${var.vm_name}-RAM-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vm_id]
  description         = "Triggers when less than 500 MB memory is unused"

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachines"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = 500000 # 500 MB
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}


# -------------------- Key Vault monitoring --------------------

resource "azurerm_monitor_activity_log_alert" "main" {
  name                = "key-vault-activitylogalert"
  resource_group_name = var.resource_group_name
  scopes              = [var.key_vault_id]
  description         = ""

  criteria {
    category       = "Administrative"
    operation_name = "Microsoft.KeyVault/vaults/read"
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

