configuration TestConfig
{
    
    Import-DSCResource -ModuleName xPSDesiredStateConfiguration

    Node ServiceHost
    {
        #Create the directory where the service will live. You should set as you prefer.
        File SetupDir
        {
            Ensure = "Present"
            Type = "Directory"
            DestinationPath = "C:\Setup"
        }

        #Download the service zip file. You should update the URL and zip file names accordingly.
        xRemoteFile DownloadPackage 
        {  
            DependsOn       = "[File]SetupDir"
            Uri             = "<Insert SAS URL to Zip file containing service>"
            DestinationPath = "c:\Setup\DemoService.zip"
            MatchSource     = $false
        }

        #Extract the contents of the zip file to the target service directory.
        Archive ExtractPackage 
        {
            DependsOn = '[xRemoteFile]DownloadPackage'
            Ensure = "Present"  # You can also set Ensure to "Absent"
            Path = "C:\Setup\DemoService.zip"
            Destination = "C:\Setup"
        }

        #Install and start the windows service
        xService EnsureServiceStarted {
            DependsOn = '[Archive]ExtractPackage'
            Ensure = 'Present'
            Name = 'DemoService'
            DisplayName = 'DemoService'
            Description = 'My Demo Service'
            Path = 'C:\Setup\DemoService.exe'
            StartupType = 'Automatic'
            State = 'Running'
        }
    }
}