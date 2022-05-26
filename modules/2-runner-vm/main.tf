# GitHub Actions provisioning pipeline runner / build machine 

# Cloud init setup script.
data "template_file" "init" {
  template = file("${path.module}/scripts/init.sh")

  vars = {
    github_token = var.github_token
    webhook_url  = var.webhook_url 
  }
}

# Creates SSH key pair
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}
# Inserts the private SSH key into Key Vault to use with bastion.
# Public key is set in VM.
# Key Vault is deployed in it's own module.
resource "azurerm_key_vault_secret" "private_ssh" {
  name         = "private-ssh"
  value        = tls_private_key.ssh_key.private_key_pem
  key_vault_id = var.key_vault_id
}

resource "azurerm_linux_virtual_machine" "vm" {
  name                = var.vm_name
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.vm_admin_username
  disable_password_authentication = true
  network_interface_ids = [
    var.interface_id,
  ]

  boot_diagnostics {
  }

  admin_ssh_key {
    username   = var.vm_admin_username
    public_key = tls_private_key.ssh_key.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
  
  identity {
    type = "SystemAssigned"
  }

  custom_data = base64encode(data.template_file.init.rendered)
}

# Gives linux VM pipeline-runner System Assigend Managed Identity,
# with contributor and key vault permissions on subscription so the VM 
# can run Terraform towards Azure and read certificates in key vault.
data "azurerm_role_definition" "contributor" {
  name = "Contributor"
}

data "azurerm_role_definition" "keyvaul" {
  name = "Key Vault Certificates Officer"
}

data "azurerm_subscription" "current" {
}

data "azurerm_client_config" "example" {
}

resource "azurerm_role_assignment" "contributor" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.contributor.id}"
  principal_id       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}

resource "azurerm_role_assignment" "keyvault" {
  scope              = data.azurerm_subscription.current.id
  role_definition_id = "${data.azurerm_subscription.current.id}${data.azurerm_role_definition.keyvaul.id}"
  principal_id       = azurerm_linux_virtual_machine.vm.identity[0].principal_id
}


# Enable diagnostics so we can see serial log output in the portal.
# Azure Portal -> Virtual Machine -> Boot diagnostics
resource "azurerm_log_analytics_workspace" "vmlogs" {
  name                = "vm-logs"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_monitor_diagnostic_setting" "vm" {
  name                        = "vm-diagnostics"
  target_resource_id          = azurerm_linux_virtual_machine.vm.id
  log_analytics_workspace_id  = azurerm_log_analytics_workspace.vmlogs.id

  metric {
    category = "AllMetrics"

    retention_policy {
      enabled = false
    }
  }
}
