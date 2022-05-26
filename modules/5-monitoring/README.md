# Monitoring

Creates the monitoring resources for GitHub actions' VM and Key Vault

------------------------
## Terraform Docs


### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |


### Resources

| Name | Type |
|------|------|
| [azurerm_automation_account.automation_account](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_account) | resource |
| [azurerm_automation_runbook.runbook](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_runbook) | resource |
| [azurerm_automation_webhook.rb_wh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/automation_webhook) | resource |
| [azurerm_monitor_action_group.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_action_group) | resource |
| [azurerm_monitor_activity_log_alert.main](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_activity_log_alert) | resource |
| [azurerm_monitor_metric_alert.cpu-alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [azurerm_monitor_metric_alert.ram-alert](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_metric_alert) | resource |
| [template_file.rb](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |

### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_automation_account_name"></a> [automation\_account\_name](#input\_automation\_account\_name) | n/a | `string` | `"monitoring"` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | n/a | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_runbook_name"></a> [runbook\_name](#input\_runbook\_name) | n/a | `string` | `"alert-notification"` | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | n/a | `string` | `""` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | n/a | `string` | `""` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | n/a | `string` | `""` | no |

### Outputs

No outputs.