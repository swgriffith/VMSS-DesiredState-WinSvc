variable "location" {
 description = "The location where resources will be created"
}

variable "tags" {
 description = "A map of the tags to use for the resources that are deployed"
 type        = "map"

 default = {
   environment = "staging"
   owner = "Griffith"
 }
}

variable "resource_group_name" {
 description = "The name of the resource group in which the resources will be created"
 default     = "ThrowAwayVMSS"
}

variable "vmss_vm_prefix" {
 description = "Prefixed used for all vm names in the VMSS"
 default = "demolab"
}
variable "adminUsername" {
   description = "User name to use as the admin account on the VMs that will be part of the VM Scale Set"
   default     = "azureuser"
}

variable "adminPassword" {
   description = "Default password for admin account"
}

variable "instanceCount" {
   description = "VMSS VM Instance Count"
   default = 2
}

variable "dnsprefix" {
    description = "VMSS Load Balancer Public IP - For RDP NAT"
}

variable "automationRegistrationURL" {
    description = "URL to register nodes with Azure Automation Desired State Configuration"
}

variable "registrationKey" {
    description = "Registratoin Key to register nodes with Azure Automation Desired State Configuration"
}

variable "nodeConfigurationName" { 
    description = "Name of node configuration to apply from Desired State Configuration"
}