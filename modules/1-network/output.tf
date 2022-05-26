output "interface_id" {
    value = azurerm_network_interface.vm.id
}

output "subnet_id" {
    value = azurerm_subnet.azurebastionsubnet.id
}

output "public_ip" {
    value = azurerm_public_ip.bastion.id
}