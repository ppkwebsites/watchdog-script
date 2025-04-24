# 🐶 pfSense Watchdog Script (Windows Batch)

This is a batch script that monitors the network connection to a pfSense VM. 
If the pfSense firewall at `192.168.1.2` stops responding to pings, the script will automatically **power off** and **restart** the VirtualBox VM named `pfsense`.

---

## 💡 Features

- Ping-based health check for pfSense
- Graceful VM restart using `VBoxManage`
- Countdown while pfSense boots up
- ASCII watchdog when online 🐾
- Interactive startup with timeout

---

## ⚙️ Configuration

Inside the script, you can customize:

```bat
set VM_NAME=pfsense
set PFSENSE_IP=192.168.1.2
