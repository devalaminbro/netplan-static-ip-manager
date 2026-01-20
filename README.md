# 🌐 Ubuntu Netplan Static IP Automation Tool

![OS](https://img.shields.io/badge/OS-Ubuntu%2020.04%20%2F%2022.04-orange)
![Language](https://img.shields.io/badge/Language-Bash%20Script-green)
![Safety](https://img.shields.io/badge/Safety-Auto%20Rollback-blue)

## 📖 Overview
Configuring Static IPs on modern Ubuntu servers (using Netplan/YAML) is error-prone. A single indentation error in the `.yaml` file can cause a complete network lockout, requiring physical access (KVM/Console) to fix.

This repository provides a **Fail-Safe Bash Script** that:
1.  Takes user input for IP, Gateway, and DNS.
2.  Generates a syntactically correct Netplan YAML file.
3.  **Backs up** the existing configuration.
4.  Uses `netplan try` to apply changes. If the network breaks, it automatically **reverts** to the previous config after 120 seconds.

## 🛠 Features
- 🛡️ **Safety First:** Prevents permanent disconnection using the "Try & Revert" logic.
- 🧹 **Clean Syntax:** Generates perfect YAML indentation automatically.
- 📦 **Auto-Backup:** Saves the old config as `backup-config.yaml` before applying changes.
- ⚡ **Instant Apply:** Applies IP changes without rebooting the server.

## 🚀 Usage Guide

### 1. Download
Clone the repository on your server:
```bash
git clone [https://github.com/devalaminbro/netplan-static-ip-manager.git](https://github.com/devalaminbro/netplan-static-ip-manager.git)
cd netplan-static-ip-manager

2. Make Executable
chmod +x set_ip.sh

3. Run the Wizard
Run with root privileges:
sudo ./set_ip.sh

4. Follow the Prompts
Enter Interface Name (e.g., eth0): eth0
Enter Static IP (CIDR format, e.g., 192.168.1.50/24): 192.168.1.50/24
Enter Gateway IP: 192.168.1.1
Enter DNS Servers (comma separated): 8.8.8.8,1.1.1.1

The script will apply the config and ask for confirmation. If you lose connection, it will restore the old IP automatically.

Author: Sheikh Alamin Santo
Cloud Infrastructure Specialist & System Administrator
