# Deploy VMSS Connected to Azure Automation DSC 
The template and parameters file here will allow you to create a VM Scale Set that registers all machines with Azure Automation DSC and applies configuration. 

To run this you must have an Azure Automation account created with State Configuration setup. See the following guide for that setup.

[Azure Automation State Configuration Setup](https://docs.microsoft.com/en-us/azure/automation/automation-dsc-getting-started)


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