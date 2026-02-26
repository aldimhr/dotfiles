#!/bin/bash

# Build menu
menu="🔍 Scan for new devices\n"
menu+="---\n"

# Get list of paired devices
devices=$(echo "devices Paired" | bluetoothctl | tail -n +2 | grep "^Device" | cut -d ' ' -f 2-)

if [ -n "$devices" ]; then
    menu+="💾 Paired Devices:\n"
    while IFS= read -r line; do
        mac=$(echo "$line" | awk '{print $1}')
        name=$(echo "$line" | cut -d ' ' -f 2-)
        
        # Check if connected
        if echo "info $mac" | bluetoothctl | grep -q "Connected: yes"; then
            menu+="  ✓ $name (Connected)\n"
        else
            menu+="  $name\n"
        fi
    done <<< "$devices"
else
    menu+="💾 No paired devices\n"
fi

# Show menu
choice=$(echo -e "$menu" | wofi --dmenu --prompt "Bluetooth" --width 350 --height 300)

if [ -z "$choice" ]; then
    exit 0
fi

# Handle choice
case "$choice" in
    "🔍 Scan for new devices")
        # Start scanning
        notify-send "Bluetooth" "Scanning for devices..." -t 2000
        
        # Turn on bluetooth if off
        echo "power on" | bluetoothctl
        
        # Start scan in background
        echo "scan on" | bluetoothctl &
        scan_pid=$!
        
        sleep 8
        
        # Get discovered devices
        discovered=$(echo "devices" | bluetoothctl | tail -n +2 | grep "^Device" | cut -d ' ' -f 2-)
        paired=$(echo "devices Paired" | bluetoothctl | tail -n +2 | grep "^Device" | cut -d ' ' -f 1)
        
        scan_menu=""
        while IFS= read -r line; do
            mac=$(echo "$line" | awk '{print $1}')
            name=$(echo "$line" | cut -d ' ' -f 2-)
            
            # Skip if already paired
            if echo "$paired" | grep -q "$mac"; then
                continue
            fi
            
            # Check signal strength or connection capability
            if echo "info $mac" | bluetoothctl | grep -q "RSSI"; then
                rssi=$(echo "info $mac" | bluetoothctl | grep "RSSI" | awk '{print $2}')
                scan_menu+="📱 $name [$mac] (RSSI: $rssi)\n"
            else
                scan_menu+="📱 $name [$mac]\n"
            fi
        done <<< "$discovered"
        
        # Stop scanning
        kill $scan_pid 2>/dev/null
        echo "scan off" | bluetoothctl
        
        if [ -z "$scan_menu" ]; then
            notify-send "Bluetooth" "No new devices found" -t 2000
            exit 0
        fi
        
        # Show discovered devices
        device_choice=$(echo -e "$scan_menu" | wofi --dmenu --prompt "Select Device to Pair" --width 400 --height 400)
        
        if [ -n "$device_choice" ]; then
            # Extract MAC address
            device_mac=$(echo "$device_choice" | grep -oP '\[.*?\]' | tr -d '[]')
            device_name=$(echo "$device_choice" | sed 's/📱 //' | sed 's/ \[.*\]//')
            
            notify-send "Bluetooth" "Pairing with $device_name..." -t 2000
            
            # Pair and connect
            echo "pair $device_mac" | bluetoothctl
            sleep 2
            echo "trust $device_mac" | bluetoothctl
            sleep 1
            echo "connect $device_mac" | bluetoothctl
            
            if [ $? -eq 0 ]; then
                notify-send "Bluetooth" "Successfully paired and connected to $device_name" -t 3000
            else
                notify-send "Bluetooth" "Paired $device_name but connection failed. Try connecting manually." -t 3000
            fi
        fi
        ;;
        
    *)
        # Handle paired device connection/disconnection
        device_name=$(echo "$choice" | sed 's/^[✓ ]*//' | sed 's/ (Connected)$//')
        
        # Skip if it's a header or separator
        if [[ "$device_name" == "💾 Paired Devices:" ]] || [[ "$device_name" == "💾 No paired devices" ]] || [[ "$device_name" == "---" ]]; then
            exit 0
        fi
        
        # Find MAC address
        mac=$(echo "devices Paired" | bluetoothctl | grep "^Device" | grep "$device_name" | awk '{print $2}')
        
        if [ -z "$mac" ]; then
            exit 0
        fi
        
        # Check current connection status and toggle
        if echo "info $mac" | bluetoothctl | grep -q "Connected: yes"; then
            # Disconnect
            echo "disconnect $mac" | bluetoothctl
            notify-send "Bluetooth" "Disconnected from $device_name" -t 2000
        else
            # Connect
            echo "connect $mac" | bluetoothctl
            if [ $? -eq 0 ]; then
                notify-send "Bluetooth" "Connected to $device_name" -t 2000
            else
                notify-send "Bluetooth" "Failed to connect to $device_name" -t 2000
            fi
        fi
        ;;
esac
