
resource "azurerm_bastion_host" "bastion" {
  name                = "connect-to-runner-bastion"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip
  }
}