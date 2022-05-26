# GitHub Actions Self-Hosted Runner
Terraform provisioning of GitHub Actions self-hosted runner in Azure.

![visio.png](/img/visio.png)

## File tree structure

📦terraform-azure-github-actions-runner <br/>
 ┣ 📂 [.github/](.github) <br/>
 ┃ ┣ 📂 [workflows](.github/workflows) <br/>
 ┃ ┃ ┣ 📜 [terraform-test.yaml](.github/workflows/terraform-tests.yml) <br/>
 ┣ 📂 [modules/](modules) <br/>
 ┃ ┣ 📂 [1-network/](modules/1-network) <br/>
 ┃ ┃ ┣ 📜 [main.tf](modules/1-network/main.tf) <br/>
 ┃ ┃ ┣ 📜 [output.tf](modules/1-network/output.tf) <br/>
 ┃ ┃ ┣ 📜 [readme.md](modules/1-network/readme.md) <br/>
 ┃ ┃ ┗ 📜 [variables.tf](modules/1-network/variables.tf) <br/>
 ┃ ┣ 📂 [2-runner-vm/](modules/2-runner-vm) <br/>
 ┃ ┃ ┣ 📂 [scripts/](modules/2-runner-vm/scripts) <br/>
 ┃ ┃ ┃ ┣ 📜 [init.sh](modules/2-runner-vm/scripts/init.sh) <br/>
 ┃ ┃ ┣ 📜 [main.tf](modules/2-runner-vm/main.tf) <br/>
 ┃ ┃ ┣ 📜 [output.tf](modules/2-runner-vm/output.tf) <br/>
 ┃ ┃ ┣ 📜 [readme.md](modules/2-runner-vm/readme.md) <br/>
 ┃ ┃ ┗ 📜 [variables.tf](modules/2-runner-vm/variables.tf) <br/>
 ┃ ┣ 📂 [3-bastion/](modules/3-bastion) <br/>
 ┃ ┃ ┣ 📜 [main.tf](modules/3-bastion/main.tf) <br/>
 ┃ ┃ ┣ 📜 [output.tf](modules/3-bastion/output.tf) <br/>
 ┃ ┃ ┣ 📜 [readme.md](modules/3-bastion/readme.md) <br/>
 ┃ ┃ ┗ 📜 [variables.tf](modules/3-bastion/variables.tf) <br/>
 ┃ ┣ 📂 [4-key-vault/](modules/4-key-vault) <br/>
 ┃ ┃ ┣ 📜 [main.tf](modules/4-key-vault/main.tf) <br/>
 ┃ ┃ ┣ 📜 [output.tf](modules/4-key-vault/output.tf) <br/>
 ┃ ┃ ┣ 📜 [readme.md](modules/4-key-vault/readme.md) <br/>
 ┃ ┃ ┗ 📜 [variables.tf](modules/4-key-vault/variables.tf) <br/>
 ┃ ┗ 📂 [5-monitoring/](modules/5-monitoring) <br/>
 ┃ ┃ ┣ 📂 [scripts/](modules/5-monitoring/scripts) <br/>
 ┃ ┃ ┃ ┗ 📜 [runbook.ps1](modules/5-monitoring/scripts/runbook.ps1) <br/>
 ┃ ┃ ┣ 📜 [main.tf](modules/5-monitoring/main.tf) <br/>
 ┃ ┃ ┣ 📜 [output.tf](modules/5-monitoring/output.tf) <br/>
 ┃ ┃ ┗ 📜 [varibles.tf](modules/5-monitoring/varibles.tf) <br/>
 ┣ 📜 [backend.tf](backend.tf) <br/>
 ┣ 📜 [backend_override.tf](backend_override.tf) <br/>
 ┣ 📜 [main.tf](main.tf) <br/>
 ┣ 📜 [output.tf](output.tf) <br/>
 ┣ 📜 [README.md](README.md) <br/>
 ┣ 📜 [service-principal-config-script.ps1](service-principal-config-script.ps1) <br/>
 ┗ 📜 [variables.tf](variables.tf) <br/>



## Initial Setup Before Provisioning

### Add token from GitHub in root variables.tf

Go to GitHub -> settings -> Actions -> Runners -> New runner

Copy the token and paste it into the root variables.tf file.

<img src="/img/githubtoken.png" alt="githubtoken" style="zoom:50%;" />

### Add a webhook url for notification when the runner is configured and other alerts (optional)
Add a url in root variables.tf file.

## Give GitHub Ations Permissions in Azure

### Create Service Principal with Azure CLI:

```
az ad sp create-for-rbac --name "github-actions" --role Contributor --scopes /subscriptions/<subscription-id> --sdk-auth 
```

### Add Service Principal information in GitHub Secrets

| Name in GitHub Secrets | Output from *az ad sp*              |
| ---------------------- | ----------------------------------- |
| TF_ARM_CLIENT_ID       | appId                               |
| TF_ARM_CLIENT_SECRET   | password                            |
| TF_ARM_TENANT_ID       | tenant                              |
| TF_ARM_SUBSCRIPTION_ID | Add subscription id (not in output) |

These values will be used in the pipelines when using the runner for other repositories. The outputs from *az ad sp* must be added in GitHub Secrets in the repository where the runner will be used. 

### Configure the permissions

**Set roles with [service-principal-config-script.ps1](https://github.com/secure-and-compliant-iac/terraform-azure-github-actions-runner/blob/main/service-principal-config-script.ps1)**



## Resources:

- [Linux Virtual Machine in Azure](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/overview) is provisioned with initial configuration for GitHub Actions self-hosted runner:
  - Docker
  - Node and npm
  - Azure CLI
  - PowerShell
  - Terraform
  - GitHub Actions
- [Azure Bastion](https://docs.microsoft.com/en-us/azure/bastion/bastion-overview) which is used to connect to the Linux virtual machine if manual configuration is needed.
- [Azure Key Vault](https://docs.microsoft.com/en-us/azure/key-vault/general/overview) is used to store the private SSH-key to use when connecting to the VM with Bastion.
- [Azure Monitor](https://docs.microsoft.com/en-us/azure/azure-monitor/overview) is used to monitor the metrics on the VM and activity on the Key Vault.



------------------------------------------------

## Terraform documentation

### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~>2.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 3.0 |

### Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 2.99.0 |

### Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_bastion"></a> [bastion](#module\_bastion) | ./modules/3-bastion | n/a |
| <a name="module_key-vault"></a> [key-vault](#module\_key-vault) | ./modules/4-key-vault | n/a |
| <a name="module_monitoring"></a> [monitoring](#module\_monitoring) | ./modules/5-monitoring | n/a |
| <a name="module_network"></a> [network](#module\_network) | ./modules/1-network | n/a |
| <a name="module_runner-vm"></a> [runner-vm](#module\_runner-vm) | ./modules/2-runner-vm | n/a |

### Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.terraform_backend](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

### Inputs

| Name | Description | Type | Default | Should Default be changed? |
|------|-------------|------|---------|:--------:|
| <a name="input_github_token"></a> [github\_token](#input\_github\_token) | Token from GitHub. Is passed into modules/2-runner-vm/scripts/init.sh | `string` | `"<Set in GitHub token>"` | yes |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | `"norwayeast"` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | `"github-actions"` | no |
| <a name="input_webhook_url"></a> [webhook\_url](#input\_webhook\_url) | A webhook url for alerts and when runner is configured. | `string` | `"https://example_webhook.com/123abc"` | yes |

### Outputs

No outputs.