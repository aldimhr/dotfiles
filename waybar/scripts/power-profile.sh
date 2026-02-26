#!/bin/bash

# Get current profile
current=$(powerprofilesctl get)

# Show menu and get selection
choice=$(echo -e "performance\nbalanced\npower-saver" | wofi --dmenu --prompt "Power Profile" --width 200 --height 150)

# Apply selected profile
if [ -n "$choice" ]; then
    powerprofilesctl set "$choice"
    notify-send "Power Profile" "Switched to $choice mode" -t 2000
fi
