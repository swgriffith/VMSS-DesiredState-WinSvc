resource "azurerm_public_ip" "vmss" {
  name                = "vmss-public-ip"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  allocation_method   = "Static"
  domain_name_label   = "${var.dnsprefix}"
  tags                = "${var.tags}"
}

resource "azurerm_lb" "vmss" {
  name                = "vmss-lb"
  depends_on          = ["azurerm_public_ip.vmss"]
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"

  frontend_ip_configuration {
    name                 = "PublicIPAddress"
    public_ip_address_id = "${azurerm_public_ip.vmss.id}"
  }

  tags = "${var.tags}"
}

resource "azurerm_lb_backend_address_pool" "vmss" {
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  loadbalancer_id     = "${azurerm_lb.vmss.id}"
  name                = "BackEndAddressPool"
  depends_on          = ["azurerm_lb.vmss"]
}

resource "azurerm_lb_probe" "vmss" {
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  loadbalancer_id     = "${azurerm_lb.vmss.id}"
  name                = "tcpProbe"
  depends_on          = ["azurerm_lb.vmss"]
  protocol            = "tcp"
  port                = 3389
  interval_in_seconds = 5
  number_of_probes    = 2
}

resource "azurerm_lb_nat_pool" "vmss" {
  resource_group_name            = "${azurerm_resource_group.vmss.name}"
  loadbalancer_id                = "${azurerm_lb.vmss.id}"
  name                           = "WinSvcPool"
  depends_on                     = ["azurerm_lb.vmss"]
  protocol                       = "Tcp"
  frontend_port_start            = 50000
  frontend_port_end              = 50119
  backend_port                   = 3389
  frontend_ip_configuration_name = "PublicIPAddress"
}
