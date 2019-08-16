resource "azurerm_resource_group" "vmss" {
  name     = "${var.resource_group_name}"
  location = "${var.location}"
  tags     = "${var.tags}"
}

resource "azurerm_virtual_network" "vmss" {
  count               = "${var.useExistingSubnet ? 0 : 1}"
  name                = "vmss-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  tags                = "${var.tags}"
}

resource "azurerm_subnet" "vmss" {
  count                = "${var.useExistingSubnet ? 0 : 1}"
  depends_on           = ["azurerm_virtual_network.vmss"]
  name                 = "vmss-subnet"
  resource_group_name  = "${azurerm_resource_group.vmss.name}"
  virtual_network_name = "${azurerm_virtual_network.vmss.0.name}"
  address_prefix       = "10.0.2.0/24"
}

