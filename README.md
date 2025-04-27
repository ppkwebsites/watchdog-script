   WatchDog
   ========
   pfSense is online...

    / \__
   (    @\___
   /         O
  /   (_____ /
 /_____/   U
      ppk


A simple batch script to monitor and restart a pfSense VM running in VirtualBox if it becomes unreachable.

🛠 Features
✅ User confirmation prompt (with 10s timeout).

✅ Ping monitoring of pfSense's IP address.

✅ Automatic VM restart on failure detection.

✅ Countdown timer while pfSense reboots.

✅ Fun ASCII art when pfSense is online!

📜 Script Overview
Filename: watchdog.bat

This script monitors a pfSense virtual machine by repeatedly pinging its IP address. If it stops responding:

It will forcefully power off the VM.

Start the VM again.

Wait 240 seconds (4 minutes) to allow pfSense to boot properly.

Resume monitoring.

📋 How It Works
1. Set Variables
At the top of the script, configure:

set VM_NAME=pfsense
set PFSENSE_IP=192.168.1.1
2. User Prompt
When running the script:

It asks if you want to start the watchdog.

Auto-continues in 10 seconds if no choice is made.

3. Connection Test
Initially pings pfSense three times to verify reachability:

ping -n 3 %PFSENSE_IP%
4. Monitoring Loop
Pings pfSense silently.

If unreachable:

Powers off the VM.

Starts the VM again.

Waits 4 minutes to boot.

If reachable:

Displays WatchDog ASCII art once.

5. Countdown Timer
A dynamic countdown timer appears while pfSense is rebooting.

⚙️ Requirements
Windows OS.

Oracle VirtualBox installed.

VBoxManage.exe at C:\Program Files\Oracle\VirtualBox\VBoxManage.exe.

Correct pfSense VM name set in the script.

🖼️ ASCII Art Preview
When pfSense is online:

   WatchDog
   ========
   pfSense is online...

    / \__
   (    @\___
   /         O
  /   (_____ /
 /_____/   U
      ppk
🚀 How To Use
Edit watchdog.bat and set the correct VM name and pfSense IP.

Double-click watchdog.bat to start.

Let it run in the background!

📢 Notes
If you reboot pfSense manually, restart the script afterwards.

Adjust VBoxManage paths if needed.

📃 License
MIT License — free to modify, share, and improve.

✨ Future Improvements
Add sound alerts.

Add email notification.

Advanced service checks beyond ping.
