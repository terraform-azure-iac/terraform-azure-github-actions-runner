resource "azurerm_resource_group" "terraform_backend" {
  name                = var.resource_group_name
  location            = var.location
}

module "network" {
    source              = "./modules/1-network"
    resource_group_name = azurerm_resource_group.terraform_backend.name
    location            = azurerm_resource_group.terraform_backend.location
}

module "runner-vm" {
    source              = "./modules/2-runner-vm"
    resource_group_name = azurerm_resource_group.terraform_backend.name
    location            = azurerm_resource_group.terraform_backend.location
    interface_id        = module.network.interface_id
    key_vault_id        = module.key-vault.key_vault_id
    github_token        = var.github_token
    webhook_url         = var.webhook_url 
}

 # Only needed for manual configuration of the GitHub Action runner
module "bastion" {
    source              = "./modules/3-bastion"
    resource_group_name = azurerm_resource_group.terraform_backend.name
    location            = azurerm_resource_group.terraform_backend.location
    subnet_id           = module.network.subnet_id
    public_ip           = module.network.public_ip
}

module "key-vault" {
    source              = "./modules/4-key-vault"
    resource_group_name = azurerm_resource_group.terraform_backend.name
    location            = azurerm_resource_group.terraform_backend.location
}

module "monitoring" {
    source              = "./modules/5-monitoring"
    resource_group_name = azurerm_resource_group.terraform_backend.name
    location            = azurerm_resource_group.terraform_backend.location
    vm_name             = module.runner-vm.vm_name
    vm_id               = module.runner-vm.vm_id
    key_vault_id        = module.key-vault.key_vault_id
    webhook_link         = var.webhook_url
}



