#!/bin/bash

# Enable colorful output
RED="\033[1;31m"
GREEN="\033[1;32m"
YELLOW="\033[1;33m"
BLUE="\033[1;34m"
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}Starting Advanced Ubuntu Server Optimization Script...${RESET}"

# Step 1: Update System Packages
echo -e "${BLUE}Updating system packages and cleaning up...${RESET}"
sudo apt update && sudo apt upgrade -y
sudo apt autoremove -y
sudo apt clean
echo -e "${GREEN}System packages updated and cleaned.${RESET}"

# Step 2: Ensure Pi-hole services are intact
echo -e "${BLUE}Ensuring Pi-hole services are active and dependencies are intact...${RESET}"
if systemctl is-active --quiet pihole-FTL; then
    echo -e "${GREEN}Pi-hole is running as expected.${RESET}"
else
    echo -e "${RED}Pi-hole is not running. Attempting to start the service...${RESET}"
    sudo systemctl start pihole-FTL
    if systemctl is-active --quiet pihole-FTL; then
        echo -e "${GREEN}Pi-hole started successfully.${RESET}"
    else
        echo -e "${RED}Failed to start Pi-hole. Please investigate manually.${RESET}"
        exit 1
    fi
fi

# Step 3: Apply Kernel Optimizations
echo -e "${BLUE}Applying kernel optimizations...${RESET}"
sudo tee /etc/sysctl.d/99-optimized.conf > /dev/null <<EOF
# Optimize network stack
net.ipv4.tcp_window_scaling = 1
net.ipv4.tcp_fin_timeout = 15
net.ipv4.tcp_keepalive_time = 300
net.core.netdev_max_backlog = 5000
net.core.rmem_max = 16777216
net.core.wmem_max = 16777216

# Reduce swap usage
vm.swappiness = 10
vm.dirty_ratio = 15
vm.dirty_background_ratio = 5

# Enable SYN flood protection
net.ipv4.tcp_syncookies = 1

# Optional: Enable IPv6 optimizations
net.ipv6.conf.all.forwarding = 1
EOF
sudo sysctl --system
echo -e "${GREEN}Kernel parameters optimized.${RESET}"

# Step 4: Configure Disk I/O and SWAP
echo -e "${BLUE}Configuring disk I/O and dynamic SWAP management...${RESET}"
sudo sed -i '/vm.swappiness/c\vm.swappiness=10' /etc/sysctl.conf
sudo swapoff -a && sudo swapon -a
echo -e "${GREEN}SWAP management configured.${RESET}"

# Step 5: Advanced Logging Setup
echo -e "${BLUE}Setting up advanced logging for performance monitoring...${RESET}"
sudo apt install -y sysstat
sudo systemctl enable sysstat
sudo systemctl start sysstat
echo -e "${GREEN}Logging setup complete.${RESET}"

# Step 6: Configure Unattended Upgrades
echo -e "${BLUE}Configuring automatic security updates...${RESET}"
sudo apt install -y unattended-upgrades
sudo dpkg-reconfigure -plow unattended-upgrades
echo -e "${GREEN}Unattended upgrades configured.${RESET}"

# Step 7: Firewall Optimization (UFW)
echo -e "${BLUE}Setting up UFW rules...${RESET}"
sudo apt install -y ufw
sudo ufw allow OpenSSH
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
sudo ufw allow 80/tcp
sudo ufw enable --force
echo -e "${GREEN}Firewall configured with Pi-hole rules.${RESET}"

# Step 8: Automate Pi-hole Updates
echo -e "${BLUE}Setting up automatic Pi-hole updates...${RESET}"
echo "0 3 * * * root pihole -up && pihole -g" | sudo tee /etc/cron.d/pihole-update > /dev/null
echo -e "${GREEN}Pi-hole updates scheduled via cron.${RESET}"

# Step 9: Improved Time Synchronization
echo -e "${BLUE}Improving NTP synchronization...${RESET}"
sudo apt install -y chrony
sudo systemctl enable chrony
sudo systemctl start chrony
echo -e "${GREEN}NTP synchronization enabled with Chrony.${RESET}"

# Step 10: Monitor Resources with Alerts
echo -e "${BLUE}Installing resource monitoring tools and alerts...${RESET}"
sudo apt install -y monit
sudo tee /etc/monit/conf.d/system > /dev/null <<EOF
check system localhost
    if loadavg (1min) > 2 then alert
    if memory usage > 75% then alert
    if cpu usage (user) > 80% then alert
EOF
sudo systemctl restart monit
echo -e "${GREEN}Resource monitoring configured.${RESET}"

# Step 11: Custom MOTD (Message of the Day)
echo -e "${BLUE}Creating a custom MOTD with server stats...${RESET}"
sudo tee /etc/update-motd.d/99-custom > /dev/null <<'EOF'
#!/bin/bash
echo -e "\033[1;32mWelcome to your optimized Ubuntu server!\033[0m"
echo -e "\033[1;34mCurrent system stats:\033[0m"
echo "-----------------------------------"
echo "Uptime: $(uptime -p)"
echo "Memory Usage: $(free -h | awk 'NR==2 {print $3 " / " $2}')"
echo "Disk Usage: $(df -h / | awk 'NR==2 {print $3 " / " $2}')"
echo "-----------------------------------"
EOF
sudo chmod +x /etc/update-motd.d/99-custom
echo -e "${GREEN}Custom MOTD created.${RESET}"

# Step 12: Reboot Prompt
echo -e "${YELLOW}Optimization complete. A system reboot is recommended.${RESET}"
read -p "Would you like to reboot now? (y/n): " REBOOT
if [[ $REBOOT =~ ^[Yy]$ ]]; then
    echo -e "${CYAN}Rebooting system...${RESET}"
    sudo reboot
else
    echo -e "${GREEN}Reboot skipped. Please remember to reboot later.${RESET}"
fi
