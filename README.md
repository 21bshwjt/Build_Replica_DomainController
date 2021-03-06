<h1 align="center">
  <img width="45" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
  Build Replica DomainController
  <img width="45" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
</h1>


### Prerequisites
- One existing Domain Controller 
- WinRM 

Build (DcPromo) a Domain Controller over the network is a pain; mainly when NTDS.DIT size is big. Another one time consuming activity is replacing an existing Domain Controller.
Above code won't take more than 20/25 mins to build a Domain Controller if NTDS.DIT within 10 GB. DSRM password need to provide by Admins.

Usecase : Manual DC build is a time taking activity & that will take minimum 4/5 hrs. over the network ; this code won't take more than 30 minutes to build a DC; if another DC is present into the same subnet. 

### N.B
```diff
# 1. Time can vary on VM & Network performances as well.
# 2. Sysvol will build automatically after the reboot.
# 3. Manual reboot is needed after promotion is completed.
# 4. Addtional log will be created in C:\temp folder.
# 5. Code tested multiple times in production but still test that Code once before moving to Prod.
# 6. Tested on On-Prem & Azure Virtual machines successfully.
```

```diff
- Do not forget to remove the IFM Backup once Domain Controller promotion will be completed.
```
___________________________________________________________________________________________________________________

- [**Wiki**](https://21bshwjt.github.io/Build_Replica_DomainController/)
- [**Me@LinkedIn**](https://www.linkedin.com/in/bshwjt/)
