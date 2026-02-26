#!/bin/bash

# Get the active WiFi interface
interface=$(nmcli device status | grep wifi | head -n 1 | awk '{print $1}')

if [ -z "$interface" ]; then
    notify-send "WiFi" "No WiFi interface found" -t 2000
    exit 0
fi

# Get current connection
current=$(nmcli -t -f NAME connection show --active | grep -v "lo\|Wired")

# Build menu
menu="📡 Scan for networks\n"

if [ -n "$current" ]; then
    menu+="🔌 Disconnect from $current\n"
    menu+="---\n"
fi

# Get saved connections
saved=$(nmcli -t -f NAME connection show | grep -v "lo\|Wired")

if [ -n "$saved" ]; then
    menu+="💾 Saved Networks:\n"
    while IFS= read -r network; do
        if [ "$network" = "$current" ]; then
            menu+="  ✓ $network (Connected)\n"
        else
            menu+="  $network\n"
        fi
    done <<< "$saved"
fi

# Show menu
choice=$(echo -e "$menu" | wofi --dmenu --prompt "WiFi" --width 350 --height 300)

if [ -z "$choice" ]; then
    exit 0
fi

# Handle choice
case "$choice" in
    "📡 Scan for networks")
        # Scan and show available networks
        nmcli device wifi rescan
        sleep 2
        
        available=$(nmcli -t -f SSID,SIGNAL,SECURITY device wifi list | sort -t: -k2 -nr)
        
        scan_menu=""
        while IFS=: read -r ssid signal security; do
            if [ -n "$ssid" ]; then
                # Signal strength indicator
                if [ "$signal" -ge 75 ]; then
                    icon="▂▄▆█"
                elif [ "$signal" -ge 50 ]; then
                    icon="▂▄▆_"
                elif [ "$signal" -ge 25 ]; then
                    icon="▂▄__"
                else
                    icon="▂___"
                fi
                
                # Security indicator
                if [ -n "$security" ] && [ "$security" != "--" ]; then
                    lock="🔒"
                else
                    lock="  "
                fi
                
                scan_menu+="$lock $icon $ssid ($signal%)\n"
            fi
        done <<< "$available"
        
        network_choice=$(echo -e "$scan_menu" | wofi --dmenu --prompt "Select Network" --width 400 --height 400)
        
        if [ -n "$network_choice" ]; then
            # Extract SSID from choice
            ssid=$(echo "$network_choice" | sed 's/^[🔒 ]*[▂▄▆█_]* //' | sed 's/ ([0-9]*%)$//')
            
            # Check if network needs password
            if echo "$network_choice" | grep -q "🔒"; then
                password=$(echo "" | wofi --dmenu --prompt "Password for $ssid" --password --width 300)
                
                if [ -n "$password" ]; then
                    nmcli device wifi connect "$ssid" password "$password"
                    if [ $? -eq 0 ]; then
                        notify-send "WiFi" "Connected to $ssid" -t 2000
                    else
                        notify-send "WiFi" "Failed to connect to $ssid" -t 2000
                    fi
                fi
            else
                nmcli device wifi connect "$ssid"
                if [ $? -eq 0 ]; then
                    notify-send "WiFi" "Connected to $ssid" -t 2000
                else
                    notify-send "WiFi" "Failed to connect to $ssid" -t 2000
                fi
            fi
        fi
        ;;
        
    "🔌 Disconnect from "*)
        network_name="${choice#🔌 Disconnect from }"
        nmcli connection down "$network_name"
        notify-send "WiFi" "Disconnected from $network_name" -t 2000
        ;;
        
    *)
        # Connect to saved network
        network=$(echo "$choice" | sed 's/^[✓ ]*//' | sed 's/ (Connected)$//')
        
        if [ "$network" != "$current" ]; then
            nmcli connection up "$network"
            if [ $? -eq 0 ]; then
                notify-send "WiFi" "Connected to $network" -t 2000
            else
                notify-send "WiFi" "Failed to connect to $network" -t 2000
            fi
        fi
        ;;
esac
