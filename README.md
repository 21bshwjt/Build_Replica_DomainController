<h1 align="center">
  <img width="45" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
  Build Replica DomainController
  <img width="45" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
</h1>

## Prerequisites
- One existing Domain Controller 
- WinRM 

Build (DcPromo) a Domain Controller over the network is a pain; mainly when NTDS.DIT size is big. Another one time consuming activity is replacing an existing Domain Controller.
Above code won't take more than 20/25 mins to build a Domain Controller if NTDS.DIT within 10 GB. DSRM password need to provide by Admins.

Usecase : Manual DC build is a time taking activity & that will take minimum 4/5 hrs. over the network ; this code won't take more than 30 minutes to build a DC; if another DC is present into the same subnet. 

```diff
- Do not foget to remove the IFM Backup.
```

#### https://21bshwjt.github.io/biswajit/
