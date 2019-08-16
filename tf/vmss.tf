resource "azurerm_virtual_machine_scale_set" "vmss" {
  name                = "vmscaleset"
  location            = "${var.location}"
  resource_group_name = "${azurerm_resource_group.vmss.name}"
  upgrade_policy_mode = "Manual"
  overprovision       = false

  sku {
    name     = "${var.vmss_vm_sku.name}"
    tier     = "${var.vmss_vm_sku.tier}"
    capacity = "${var.instanceCount}"
  }

  storage_profile_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2016-Datacenter"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name_prefix = "vmlab"
    admin_username       = "${var.adminUsername}"
    admin_password       = "${var.adminPassword}"
  }

  extension {
    name                 = "Microsoft.Powershell.DSC"
    publisher            = "Microsoft.Powershell"
    type                 = "DSC"
    type_handler_version = "2.76"
    settings             = <<SETTINGS
        {
            "Properties": [
                {
                "Name": "RegistrationKey",
                "Value": {
                    "UserName": "PLACEHOLDER_DONOTUSE",
                    "Password": "PrivateSettingsRef:registrationKeyPrivate"
                },
                "TypeName": "System.Management.Automation.PSCredential"
                },
                {
                "Name": "RegistrationUrl",
                "Value": "${var.automationRegistrationURL}",
                "TypeName": "System.String"
                },
                {
                "Name": "NodeConfigurationName",
                "Value": "${var.nodeConfigurationName}",
                "TypeName": "System.String"
                },
                {
                "Name": "ConfigurationMode",
                "Value": "ApplyandAutoCorrect",
                "TypeName": "System.String"
                },
                {
                "Name": "RebootNodeIfNeeded",
                "Value": true,
                "TypeName": "System.Boolean"
                },
                {
                "Name": "ActionAfterReboot",
                "Value": "ContinueConfiguration",
                "TypeName": "System.String"
                }
            ]
        }
        SETTINGS

    protected_settings = <<PROTECTED_SETTINGS
    {
      "Items": {
        "registrationKeyPrivate" : "${var.registrationKey}"
      }
    }
PROTECTED_SETTINGS
  }

  network_profile {
    name    = "terraformnetworkprofile"
    primary = true

    ip_configuration {
      name                                   = "IPConfiguration"
      subnet_id                              = "${azurerm_subnet.vmss.id}"
      load_balancer_backend_address_pool_ids = ["${azurerm_lb_backend_address_pool.vmss.id}"]
      load_balancer_inbound_nat_rules_ids    = ["${azurerm_lb_nat_pool.vmss.id}"]
      primary                                = true
    }
  }

  tags = "${var.tags}"
}