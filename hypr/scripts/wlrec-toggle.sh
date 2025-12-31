#!/bin/bash

PIDFILE="/tmp/wl-screenrec.pid"

if [ -f "$PIDFILE" ]; then
    # Stop recording
    kill -INT $(cat "$PIDFILE")
    rm "$PIDFILE"
    notify-send "Recording stopped"
else
    # Start recording
    FILE="$HOME/Videos/wlScreenRec/rec_$(date +%Y-%m-%d_%H-%M-%S).mp4"
    wl-screenrec -g "$(slurp)" -f "$FILE" &
    echo $! > "$PIDFILE"
    notify-send "Recording started"
fi
