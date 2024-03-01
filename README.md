<h1 align="center">
  <img width="45" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
  Build Replica DomainController
  <img width="45" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
</h1>


### Prerequisites
- One existing Domain Controller 
- WinRM 

Building (DcPromo) a Domain Controller over the network is a pain; mainly when NTDS.DIT size is big. That is a time-consuming activity in replacing an existing Domain Controller.
The above code won't take more than 20/25 mins to build a Domain Controller if NTDS.DIT within 10 GB. DSRM password needs to be provided by Admins.

**Use case**: Building a Domain Controller manually is a time-consuming process, typically requiring a minimum of 4 to 5 hours over the network. However, the provided code streamlines this task and can construct a domain controller in under 30 minutes, especially if there is another domain controller present in the local network.

### Notes
```diff
# 1. The time required can fluctuate based on the performance of both the VM and the network.
# 2. Sysvol will automatically reconstruct following a reboot.
# 3. A manual reboot is needed after the promotion is completed.
# 4. Additional logs will be created in 'C:\temp' folder.
# 5. While the code has undergone multiple successful tests in production, it is advisable to independently validate its performance before deploying it to the production environment.
# 6. Successfully tested on both On-Premises and Azure Virtual machines.
```
### Deploy first DC in your Domain
```powershell
#
# Windows PowerShell script for AD DS Deployment
#

Import-Module ADDSDeployment
Install-ADDSForest `
-CreateDnsDelegation:$false `
-DatabasePath "C:\Windows\NTDS" `
-DomainMode "WinThreshold" `
-DomainName "bshwjt.internal" `
-DomainNetbiosName "BSHWJT" `
-ForestMode "WinThreshold" `
-InstallDns:$true `
-LogPath "C:\Windows\NTDS" `
-NoRebootOnCompletion:$false `
-SysvolPath "C:\Windows\SYSVOL" `
-Force:$true
```

```diff
- Do not forget to remove the IFM Backup once the Domain Controller promotion is completed.
```
___________________________________________________________________________________________________________________

- [**Wiki**](https://21bshwjt.github.io/Build_Replica_DomainController/)
- [**Me@LinkedIn**](https://www.linkedin.com/in/bshwjt/)
