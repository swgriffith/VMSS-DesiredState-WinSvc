# Deploy VMSS Connected to Azure Automation DSC 
The template and parameters file here will allow you to create a VM Scale Set that registers all machines with Azure Automation DSC and applies configuration. 

This deployment assumes the following:
1. You already have an Azure Automation account created with State Configuration setup. See the following guide for that setup.

[Azure Automation State Configuration Setup](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started)

2. You're deploying to an existing Virtual Network and Subnet. You'll need to go to the virtual network and get the 'Resource ID' and append 'subnets/<subnetName>' (ex. /subscriptions/62a48929fc-184b-4488-77ac-e7838d4c8/resourceGroups/MyResourceGroup/providers/Microsoft.Network/virtualNetworks/MyVirtualNetwork/subnets/mysubnet). This value will be used for the 'subnetId' parameter in the deployment.

3. If you intend to connect to individual Windows nodes in the scale set you'll use the NAT created within the load balancer. This NAT translates the front end IP port range of 50000 to 50119 to port 3389 on the individual backend servers. You'll need to make sure that you have a NSG rule on your Subnet that allows those ports into the subnet.

4. The DSC script uses the xPSDesiredStateConfiguration module. You'll need to go to your Azure Automation Account and under "Modules Gallery" search for xPSDesiredStateConfiguration, and import the module into your Automation Account. It may take a few minutes before the module is available for you to use when you compile your DSC Configuration.

5. Finally, you'll want to go to your Automation Account and then to the 'State Configuration (DSC)' blade, and execute the following steps:
  - Click the 'Configurations' tab
  - Click the + link to add a new configuration
  - Choose the file explorer and chose the ps1 file containing your DSC configuration (ex. From this repo its DesiredState.ps1)
  - Once uploaded, click on the configuration and then click 'Compile'
  - Make note of the configuration name (ex. TestConfig.ServiceHost from DesiredState.ps1) as you'll use this as a parameter vaule you when you deploy the VMSS.


***Note:*** In this repo you'll also find the source for a basic DemoService Windows Service you can use for testing. This windows service, once installed and started, will create a new Application Log in the Windows Event Log called 'DemoLog'. It will write a start up and shutdown event, as well as an event per minute to show the service is alive. I've also provided a compiled copy under 'Releases'.

## To deploy this template use one of the following options.

From Azure PowerShell
```powershell
$resourceGroupName = <Insert Resource Group Name>
$location = <Insert Location (ex. eastus, westus)>

New-AzResourceGroup -Name $resourceGroupName -Location $location
New-AzResourceGroupDeployment -Name ExampleDeployment -ResourceGroupName $resourceGroupName `
  -TemplateFile c:\MyTemplates\azuredeploy.json `
  -TemplateParameterFile c:\MyTemplates\storage.parameters.json
```

From Azure Cross Platform CLI
```bash
RG=<Resource Group Name>
LOC=<Location (ex. eastus, westus)>
az group create -n $RG -l $LOC
az group deployment create -g $RG -n initialdeploy --template-file azuredeploy.json --parameters @azuredeploy.parameters.json
```