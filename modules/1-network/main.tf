resource "azurerm_virtual_network" "runnernetwork" {
  name                = "runner-network"
  address_space       = ["10.1.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name
}

resource "azurerm_subnet" "runner" {
  name                 = "GithubRunnerSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.runnernetwork.name
  address_prefixes     = ["10.1.2.0/24"]
}

resource "azurerm_subnet" "azurebastionsubnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.runnernetwork.name
  address_prefixes     = ["10.1.3.0/24"]
}

resource "azurerm_network_interface" "vm" {
  name                = "vm-nic"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.runner.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_public_ip" "bastion" {
  name                = "bastion"
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
}