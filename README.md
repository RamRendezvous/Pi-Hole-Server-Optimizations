
#**A comprehensive script to optimize your Ubuntu Server 22.04.3 for performance, security, and reliability while keeping Pi-hole dependencies intact.**

---

## **Features**

- **System Updates**: Automates package updates and cleans unnecessary files.
- **Kernel Optimizations**: Enhances TCP settings, reduces swap usage, and improves performance.
- **Disk and SWAP Management**: Configures disk I/O and dynamic SWAP adjustments.
- **Logging Setup**: Adds advanced logging using `sysstat`.
- **Firewall Configuration**: Sets up UFW with Pi-hole-friendly rules.
- **Pi-hole Maintenance**: Ensures Pi-hole is running and schedules updates.
- **Resource Monitoring**: Installs and configures `monit` for alerts.
- **Custom MOTD**: Displays system stats on login with a customized message.
- **Time Synchronization**: Ensures accurate NTP configuration with `chrony`.

---

## **Prerequisites**

- **Operating System**: Ubuntu Server 22.04.3
- **Root/Sudo Access**: The script requires administrative privileges.
- **Installed Tools**: Ensure `Pi-hole` is already installed and functional.

---

## **Installation**

1. **Clone the Repository**
   ```bash
   git clone https://github.com/RamRendeznous/ubuntu-optimization-script.git
   cd ubuntu-optimization-script
   ```

2. **Make the Script Executable**
   ```bash
   chmod +x optimize_server.sh
   ```

3. **Run the Script**
   ```bash
   sudo ./optimize_server.sh
   ```

4. **Follow the Prompts**
   - The script will guide you through optimization.
   - At the end, it will recommend a reboot to apply all changes.

---

## **Customizations**

### **Skip/Modify Specific Steps**
- Open the script in your favorite text editor:
  ```bash
  nano optimize_server.sh
  ```
- Comment out or edit sections as needed. Each step is clearly labeled for easy navigation.

### **Update MOTD**
- Modify the login message script at `/etc/update-motd.d/99-custom`.

---

## **Known Issues**

- **UFW SSH Warning**: The script uses `--force` to prevent SSH disruptions.
- **Chrony Installation**: Replaces `systemd-timesyncd` with `chrony`. If you prefer `systemd-timesyncd`, reinstall it:
  ```bash
  sudo apt install systemd-timesyncd
  ```

---

## **FAQs**

### 1. **Will this affect my Pi-hole configuration?**
   No, the script is designed to maintain Pi-hole dependencies and ensure its smooth operation.

### 2. **Can I run this script multiple times?**
   Yes, the script is safe to run repeatedly. It will skip tasks already completed.

---

## **Contributing**

- Feel free to fork this repository and submit pull requests with your improvements.
- For issues or suggestions, open a GitHub issue.

---

## **License**

This project is licensed under the [MIT License](LICENSE).

---

### **Example Output**

Below is a snippet of the script's output for reference:

```bash
Starting Advanced Ubuntu Server Optimization Script...
Updating system packages and cleaning up...
System packages updated and cleaned.
Ensuring Pi-hole services are active and dependencies are intact...
Pi-hole is running as expected.
Applying kernel optimizations...
Kernel parameters optimized.
```

---

Enjoy your optimized Pi-Hole Ubuntu server! 
