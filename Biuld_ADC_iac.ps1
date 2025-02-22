$VerbosePreference = "Continue"
$dateformat = Get-Date -format 'MM.dd.yyyy.HH.mm.ss'
# Define the path of the folder you want to create
$LoggingDirectory = "C:\DCBuild"

# Check if the folder exists
if (-Not (Test-Path -Path $LoggingDirectory)) {
    # Create the folder if it doesn't exist
    New-Item -ItemType Directory -Path $LoggingDirectory
    Write-Output "Folder created: $LoggingDirectory"
}
else {
    Write-Output "Folder already exists: $LoggingDirectory"
}

$Logpath = "$($LoggingDirectory)\DC_Built_iac_($env:COMPUTERNAME)_$($dateformat).log"
Start-Transcript -Path $Logpath -Force
$getifmsrv = Read-Host "Please Enter The Nearest Domain Controller Name"
 
Invoke-Command -ComputerName $getifmsrv -ScriptBlock {
    $IFMPATH = "C:\IFM"
    If ((Test-Path -Path $IFMPATH) -eq $true) {
            
        $Folders = Get-Childitem $IFMPATH -Recurse | Where-Object { $_.PsContainer -eq $True }
        $Folders | ForEach-Object {
    
            $strName = $_.Fullname
            $acl = get-acl $strName
            $acl.SetAccessRuleProtection($false, $false)
            $rule = New-Object System.Security.AccessControl.FileSystemAccessRule("Administrators", "Full", "ContainerInherit,ObjectInherit", "NoPropagateInherit", "Allow")
            $acl.AddAccessrule($rule)
            set-acl $strName $acl
       
        }
    
        Remove-item $IFMPATH -Force -Recurse -Verbose
        Write-Host "Old IFM Removed Successfully" -ForegroundColor Green -BackgroundColor DarkMagenta
        Start-Sleep -Seconds 5
    }
    
    @"
    ..................................................................
    ..................................................................
    ................. CODE TO CREATE IFM FILES .....................
    ..................................................................
    ..................................................................
        
    Process is about to start .......................................
    This Process can take about 15 minutes...........................
        
        
    The IFM Files will be stored on ........... $IFMPATH
           
        
"@
    
    $IFM = ntdsutil "activate instance ntds" IFM "create full $IFMPath" q q q
    
    @"
    ..................................................................
    ..................................................................
    ................  IFM FILES CREATION COMPLETED ...................
    ..................................................................
    ..................................................................
             
    Output of IFM Opertaion ..........................................
        
"@
    
    $IFM
    
    IF ($IFM -like "*IFM media created successfully*") {
        Write-Host "IFM Code Successfully Created the IFM Media Set" `r -ForegroundColor Green
        $Success = "True"
    }
  
  
}
Start-Sleep -Seconds 15
#Copy IFM to Local Server
Net use Z: \\$getifmsrv\c$\IFM
Robocopy Z: C:\IFM /copyall /s
Start-Sleep -Seconds 5
#Intall Prereqs
Add-WindowsFeature AD-Domain-Services, RSAT-ADDS, RSAT-ADDS-Tools, RSAT-AD-AdminCenter, RSAT-AD-PowerShell, RSAT-DNS-Server, RSAT-ADLDS, SNMP-Service, SNMP-WMI-Provider -Verbose
Start-Sleep -Seconds 5
#Promote Domain Controllers
Install-ADDSDomainController -CreateDnsDelegation:$false -DatabasePath 'C:\Windows\NTDS' -DomainName $env:USERDNSDOMAIN -InstallDns:$true -LogPath 'C:\Windows\NTDS' -NoGlobalCatalog:$false -SysvolPath 'C:\Windows\SYSVOL' -InstallationMediaPath 'C:\IFM' -NoRebootOnCompletion:$true -Force:$true
Stop-Transcript
