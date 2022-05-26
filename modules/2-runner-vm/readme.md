# Runner VM

Creates the GitHub actions runner VM.

------------------------
## Terraform Docs


### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | n/a |
| <a name="provider_template"></a> [template](#provider\_template) | n/a |
| <a name="provider_tls"></a> [tls](#provider\_tls) | n/a |


### Resources

| Name | Type |
|------|------|
| [azurerm_key_vault_secret.private_ssh](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/key_vault_secret) | resource |
| [azurerm_linux_virtual_machine.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) | resource |
| [azurerm_log_analytics_workspace.vmlogs](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace) | resource |
| [azurerm_monitor_diagnostic_setting.vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/monitor_diagnostic_setting) | resource |
| [azurerm_role_assignment.contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [azurerm_role_assignment.keyvault](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |
| [tls_private_key.ssh_key](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [azurerm_client_config.example](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/client_config) | data source |
| [azurerm_role_definition.contributor](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_role_definition.keyvaul](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/role_definition) | data source |
| [azurerm_subscription.current](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/data-sources/subscription) | data source |
| [template_file.init](https://registry.terraform.io/providers/hashicorp/template/latest/docs/data-sources/file) | data source |


### Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | n/a | `string` | `""` | no |
| <a name="input_interface_id"></a> [interface\_id](#input\_interface\_id) | n/a | `string` | `""` | no |
| <a name="input_key_vault_id"></a> [key\_vault\_id](#input\_key\_vault\_id) | n/a | `string` | `""` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `""` | no |
| <a name="input_public_key"></a> [public\_key](#input\_public\_key) | n/a | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `""` | no |
| <a name="input_vm_admin_username"></a> [vm\_admin\_username](#input\_vm\_admin\_username) | n/a | `string` | `"runner-admin"` | no |
| <a name="input_vm_name"></a> [vm\_name](#input\_vm\_name) | n/a | `string` | `"pipeline-runner"` | no |
| <a name="input_vm_size"></a> [vm\_size](#input\_vm\_size) | n/a | `string` | `"Standard_B2s"` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | n/a | `string` | `""` | no |

### Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | n/a |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | n/a |