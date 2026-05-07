<h1 align="center">
  <img width="50" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
  &nbsp;Build Replica Domain Controller&nbsp;
  <img width="50" src="https://github.com/21bshwjt/Build_Replica_DomainController/blob/68e1d154cc2110bdb5dbf74418c9ec60b5bc5024/images/adds.png?raw=true">
</h1>

<p align="center">
  <b>Automate Active Directory Domain Controller promotion in under 30 minutes — on-premises or Azure.</b>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows%20Server-0078D4?style=flat-square&logo=windows&logoColor=white"/>
  <img src="https://img.shields.io/badge/Language-PowerShell-5391FE?style=flat-square&logo=powershell&logoColor=white"/>
  <img src="https://img.shields.io/badge/Tested-On--Premises%20%7C%20Azure%20VM-brightgreen?style=flat-square"/>
  <img src="https://img.shields.io/badge/DC%20Build%20Time-~20–30%20min-orange?style=flat-square"/>
</p>

<p align="center">
  <a href="https://21bshwjt.github.io/Build_Replica_DomainController/">📘 Wiki</a> &nbsp;|&nbsp;
  <a href="https://www.linkedin.com/in/bshwjt/">💼 LinkedIn</a>
</p>

---

## 📋 Overview

Promoting a replica Domain Controller over the network using the traditional **DCPromo / GUI method** is a notoriously slow process — often taking **4–5+ hours** when the `NTDS.DIT` database is large or the network is constrained.

This PowerShell automation uses **Install From Media (IFM)** to dramatically shrink promotion time:

| Method | Typical Time | Network Dependency |
|---|---|---|
| Traditional DCPromo (GUI) | 4–5+ hours | High — full AD DB replication |
| **This Script (IFM-based)** | **~20–30 minutes** | Low — only delta sync after promotion |

> ✅ Successfully tested in **production environments**, both **on-premises** and on **Azure Virtual Machines**.

---

## ⚙️ Prerequisites

| Requirement | Details |
|---|---|
| Existing Domain Controller | At least one DC must be reachable on the local network |
| WinRM | Must be enabled on the target server |
| NTDS.DIT Size | Optimised for databases within **10 GB** |
| DSRM Password | Must be supplied by the Administrator at runtime |
| Permissions | Domain Admin or equivalent |

---

## 🚀 Operations

---

### 1️⃣ Deploy the First DC — Build a New Forest

Use this block to promote the **first Domain Controller** in a brand-new AD forest. This is a one-time operation when standing up a new domain from scratch.

```powershell
#
# Windows PowerShell script for AD DS Deployment — New Forest
#
Import-Module ADDSDeployment

Install-ADDSForest `
    -CreateDnsDelegation:$false `
    -DatabasePath          "C:\Windows\NTDS" `
    -DomainMode            "WinThreshold" `
    -DomainName            "bshwjt.internal" `
    -DomainNetbiosName     "BSHWJT" `
    -ForestMode            "WinThreshold" `
    -InstallDns:$true `
    -LogPath               "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$false `
    -SysvolPath            "C:\Windows\SYSVOL" `
    -Force:$true
```

> 💡 Update `-DomainName` and `-DomainNetbiosName` to match your environment before running.

---

### 2️⃣ Build a Replica DC Using IFM (Install From Media)

This is the core automation — promoting an additional DC into an existing domain using an IFM backup, bypassing full network-based replication.

> ⚠️ **Important:** Once DC promotion is complete, **remove the IFM backup immediately** to avoid leaving sensitive AD data on disk.

```powershell
#
# Windows PowerShell script for AD DS Deployment — Replica DC via IFM
#
Import-Module ADDSDeployment

Install-ADDSDomainController `
    -NoGlobalCatalog:$false `
    -CreateDnsDelegation:$false `
    -Credential              (Get-Credential) `
    -CriticalReplicationOnly:$false `
    -DatabasePath            "C:\Windows\NTDS" `
    -DomainName              "bshwjt.internal" `
    -InstallationMediaPath   "C:\IFM" `
    -InstallDns:$true `
    -LogPath                 "C:\Windows\NTDS" `
    -NoRebootOnCompletion:$true `
    -ReplicationSourceDC     "DC01.bshwjt.internal" `
    -SiteName                "Default-First-Site-Name" `
    -SysvolPath              "C:\Windows\SYSVOL" `
    -Force:$true
```

---

## 📝 Important Notes

| # | Note |
|---|------|
| ⏱️ | Build time varies based on VM performance and network speed |
| 🔁 | **SYSVOL** will automatically reconstruct after the first reboot |
| 🔄 | A **manual reboot** is required after promotion completes |
| 📁 | Additional diagnostic logs are written to `C:\temp` |
| 🧪 | Tested successfully in production — but always **validate in a non-prod environment first** |
| ☁️ | Verified on both **on-premises** and **Azure Virtual Machines** |

---

## 🔁 Promotion Flow

```
  Target Server (WinRM enabled)
          │
          ▼
  Copy IFM Backup to C:\IFM
          │
          ▼
  Run Install-ADDSDomainController
  (IFM path supplied — minimal network replication)
          │
          ▼
  Promotion completes (~20–30 min)
          │
          ├──▶ Delete IFM backup from C:\IFM  ⚠️ Do this immediately
          │
          ▼
  Manual Reboot
          │
          ▼
  SYSVOL reconstructs automatically
          │
          ▼
  ✅ Replica DC online — logs in C:\temp
```

---

## 📚 Further Reading

- 📖 [Install-ADDSForest — Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsforest)
- 📖 [Install-ADDSDomainController — Microsoft Docs](https://learn.microsoft.com/en-us/powershell/module/addsdeployment/install-addsdomaincontroller)
- 📖 [Install AD DS from Media (IFM) — Microsoft Docs](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/deploy/ad-ds-installation-and-removal-wizard-page-descriptions#BKMK_IFM)
- 📖 [Active Directory Domain Services Overview](https://learn.microsoft.com/en-us/windows-server/identity/ad-ds/get-started/virtual-dc/active-directory-domain-services-overview)

---

## 🤝 Contributing

Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

---

<p align="center">
  <a href="https://21bshwjt.github.io/Build_Replica_DomainController/">📘 Wiki</a> &nbsp;•&nbsp;
  <a href="https://www.linkedin.com/in/bshwjt/">💼 Connect on LinkedIn</a>
</p>
