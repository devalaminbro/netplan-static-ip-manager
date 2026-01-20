```bash
#!/bin/bash

# ============================================================
# Ubuntu Netplan Static IP Manager
# Author: Sheikh Alamin Santo
# Description: Configures Static IP with Safety Rollback
# ============================================================

# Color Codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

# Check Root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}Please run as root (sudo ./set_ip.sh)${NC}"
  exit
fi

echo -e "${GREEN}[+] Starting Network Configuration Wizard...${NC}"

# 1. Gather Input
read -p "Enter Interface Name (e.g., eth0, ens160): " IFACE
read -p "Enter Static IP (e.g., 192.168.1.10/24): " IP_ADDR
read -p "Enter Gateway IP: " GATEWAY
read -p "Enter DNS (comma separated, e.g., 8.8.8.8,1.1.1.1): " DNS_SERVERS

# Format DNS for YAML ([8.8.8.8, 1.1.1.1])
DNS_FORMATTED="[${DNS_SERVERS}]"

# 2. Backup Existing Config
echo -e "${GREEN}[+] Backing up current Netplan config...${NC}"
cp /etc/netplan/*.yaml /etc/netplan/config_backup.yaml.bak

# 3. Generate New Config File
CONFIG_FILE="/etc/netplan/01-netcfg-static.yaml"

echo -e "${GREEN}[+] Generating YAML Configuration...${NC}"

cat > $CONFIG_FILE <<EOF
network:
  version: 2
  renderer: networkd
  ethernets:
    $IFACE:
      dhcp4: no
      addresses:
        - $IP_ADDR
      routes:
        - to: default
          via: $GATEWAY
      nameservers:
        addresses: $DNS_FORMATTED
EOF

# 4. Apply Changes Safely
echo -e "${GREEN}[+] Applying Configuration safely...${NC}"
echo "Running 'netplan try'. If you lose connection, wait 120s for rollback."

netplan try --timeout 120

# Check Exit Status
if [ $? -eq 0 ]; then
    echo -e "${GREEN}[+] Success! New IP Address Assigned.${NC}"
else
    echo -e "${RED}[!] Configuration Failed or Timed Out. Reverted to old IP.${NC}"
fi
