#!/bin/bash

# This script is the entrypoint for the Docker container.

# Set display resolution from environment variable
export VNC_RESOLUTION=${VNC_RES:-1920x1080}

# Set the VNC password if not already set (default is 'password')
VNC_PW=${VNC_PW:-password}

echo "Starting KasmVNC server with resolution ${VNC_RESOLUTION} and password set."

# Start KasmVNC server
# --skip-x-launch: KasmVNC should not start its own X server
# --interface 0.0.0.0: Listen on all interfaces
# --loopback: Only listen locally (KasmVNC will bridge for us)
# --password: Set the VNC password
# --display :0: Connect to existing X server (Xorg started by SDDM)
# --novnc-port 6901: Default KasmVNC web port
# --startup-command: Command to run after VNC is up (SDDM and KDE)

/usr/bin/kasmvncserver \
    --skip-x-launch \
    --interface 0.0.0.0 \
    --loopback \
    --password ${VNC_PW} \
    --display :0 \
    --novnc-port ${KASM_VNC_PORT} \
    --startup-command "sudo /usr/bin/sddm --autologin user --nocursor" & # Start SDDM for graphical login

# Wait for KasmVNC server to be ready
sleep 5

# Ensure the DBUS_SESSION_BUS_ADDRESS is set for KDE to function
# This part is tricky as SDDM handles session management.
# KasmVNC automatically detects the desktop.

echo "KasmVNC started. Waiting for connection on port ${KASM_VNC_PORT}"

# Keep the container running
tail -f /dev/null
