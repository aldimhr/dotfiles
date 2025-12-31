#!/bin/bash

# The daemon is already running via systemd
# We just need to export its variables to our session

# Set the control directory (we know it from systemctl output)
export GNOME_KEYRING_CONTROL="/run/user/$UID/keyring"

# Set SSH socket if it exists
if [ -S "/run/user/$UID/keyring/ssh" ]; then
    export SSH_AUTH_SOCK="/run/user/$UID/keyring/ssh"
fi

# Update dbus environment so all apps can access it
dbus-update-activation-environment --systemd GNOME_KEYRING_CONTROL SSH_AUTH_SOCK
