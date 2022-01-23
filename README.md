# Build Replica DomainController
## Preqs: 
- One existing Domain Controller 
- WinRM 

Build (DcPromo) a Domain Controller over the network is a pain; mainly when NTDS.DIT size is big. Another one time consuming activity is replacing an existing Domain Controller.
Above code won't take more than 20/25 mins to build a Domain Controller if NTDS.DIT within 10 GB. DSRM password need to provide by Admins.

Usecase : Manual DC build is a time taking activity & that will take minimum 4/5 hrs. over the network ; this code won't take more than 30 minutes to build a DC; if another DC is present into the same subnet. 

#### https://21bshwjt.github.io/biswajit/
