#!/bin/bash

# This script optimizes KDE for VNC performance during the Docker build.

# Create a dummy user config directory for KDE settings
mkdir -p /root/.config
chown root:root /root/.config

# Disable KDE Compositor (major VNC performance boost)
# Use kwriteconfig6 for KDE Plasma 6 (standard in Debian 13)
kwriteconfig6 --file /root/.config/kwinrc --group Compositing --key Enabled false
kwriteconfig6 --file /root/.config/kwinrc --group Compositing --key OpenGLIsCompositing false
kwriteconfig6 --file /root/.config/kwinrc --group Compositing --key XRenderIsCompositing false

# Apply settings for VNC-friendly performance
kwriteconfig6 --file /root/.config/kwinrc --group Effects --key "Blur Enabled" false
kwriteconfig6 --file /root/.config/kdeglobals --group General --key AllowKDEForcedShutdown true

# Ensure SDDM (KDE's display manager) autologin for 'user' (or root)
# For simplicity, we'll try to autologin as 'root' or a generic 'user' if available.
# This assumes you create a user 'user' in your Dockerfile or log in manually.
# For this example, we'll autologin root for simplicity in Docker.
# In a real scenario, you'd create a non-root user.
mkdir -p /etc/sddm.conf.d
cat << EOF > /etc/sddm.conf.d/autologin.conf
[Autologin]
User=root
Session=plasma.desktop
[X11]
ServerArguments=-nolisten tcp -noreset -audit 0
EOF

# Ensure KasmVNC specific settings for user 'root'
mkdir -p /root/.vnc
echo "${VNC_PW}" > /root/.vnc/passwd
chmod 600 /root/.vnc/passwd

echo "KDE optimization script finished."
