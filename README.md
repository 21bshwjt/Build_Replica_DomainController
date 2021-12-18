# Build Replica DomainController
## Preqs: 1) One existing Domain Controller & 2) WinRM 
1. This is build a ADC using IFM.
2. Sysvol is not included with IFM. 

Build (DcPromo) a Domain Controller over the network is a pain; mainly when NTDS.DIT size is big. Another one time consuming activity is replacing an existing Domain Controller.
Above code won't take more than 20/25 mins to build a Domain Controller if NTDS.DIT within 10 GB. DSRM password need to provide by Admins.

Usecase : Manual DC build is a time taking activity & that will take minimum 4/5 hrs. over the network ; this code won't take more than 30 minutes to build a DC; if another DC is present into the same subnet. 

#### https://21bshwjt.github.io/biswajit/
