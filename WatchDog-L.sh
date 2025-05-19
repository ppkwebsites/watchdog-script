#!/bin/bash

# CONFIGURATION
VM_NAME="pfSense"
PFSENSE_IP="192.168.1.1"
VBOX_CMD=$(command -v VBoxManage)
TARGET="8.8.8.8"
MAX_ATTEMPTS=2
REBOOT_ATTEMPTS=0
SOUND_FILE="/usr/share/sounds/freedesktop/stereo/dialog-warning.oga"  # Change if needed

# Check VBoxManage
if [[ ! -x "$VBOX_CMD" ]]; then
    echo "WARNING: VBoxManage not found. VirtualBox likely not installed."
    VBOX_AVAILABLE=0
else
    VBOX_AVAILABLE=1
fi

function play_alert_sound() {
    if command -v paplay &>/dev/null; then
        paplay "$SOUND_FILE" &
    elif command -v aplay &>/dev/null; then
        aplay "$SOUND_FILE" &
    else
        echo "No sound player found."
    fi
}

function countdown() {
    local seconds=$1
    local message="$2"
    while [ "$seconds" -gt 0 ]; do
        echo -ne "$message... $seconds seconds remaining\r"
        sleep 1
        ((seconds--))
    done
    echo -e "\n"  # add a newline to flush
}


# MAIN LOOP
while true; do
    if ! ping -c 3 -W 3 "$TARGET" &>/dev/null; then
        play_alert_sound
        clear
        echo -e "\nWatchDog"
        echo "========"
        echo -n "Internet is "
        echo -e "\e[31mDOWN!\e[0m"
        echo
        cat << "EOF"
  "  \____ "
  " (    @\___"
  " /         O"
  "/   (_^^^^^/"
  "/____/^^^^"
      ppk
EOF
    else
        avg_ping=$(ping -c 4 "$TARGET" | grep 'rtt' | awk -F '/' '{print $5 " ms"}')
        clear
        echo -e "\nWatchDog"
        echo "========"
        echo -n "Internet is "
        echo -e "\e[32mUP!\e[0m"
        echo "Average Ping Time: $avg_ping"
        echo

        if [[ "$VBOX_AVAILABLE" == 1 ]]; then
            if ! ping -c 2 -W 2 "$PFSENSE_IP" &>/dev/null; then
                if (( REBOOT_ATTEMPTS < MAX_ATTEMPTS )); then
                    echo "pfSense not responding. Attempting reboot..."
                    echo "Reboot Attempt: $REBOOT_ATTEMPTS of $MAX_ATTEMPTS"

                    echo "Executing: VBoxManage controlvm \"$VM_NAME\" poweroff"
                    $VBOX_CMD controlvm "$VM_NAME" poweroff

                    sleep 5

                    echo "Executing: VBoxManage startvm \"$VM_NAME\" --type gui"
                    $VBOX_CMD startvm "$VM_NAME" --type gui

                    ((REBOOT_ATTEMPTS++))
                    countdown 240 "Waiting for pfSense to finish booting"
                else
                    echo "Max pfSense reboot attempts reached."
                    echo "pfSense may not be running or LAN port is offline."
                fi
            else
                echo -n "pfSense is "
                echo -e "\e[32mUP!\e[0m"
                REBOOT_ATTEMPTS=0
            fi
        fi

        echo
        cat << "EOF"
  "  / \__"
  " (    @\___"
  " /         O"
  "/   (_____ /"
  "/_____/   U"
      ppk
EOF
    fi

    sleep 60
done
