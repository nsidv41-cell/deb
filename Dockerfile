# Use Debian 13 (Trixie) as the base image
FROM debian:trixie

ENV DEBIAN_FRONTEND=noninteractive

# Set environment variables for KasmVNC and KDE
ENV HOME=/headless \
    STARTUPDIR=/dockerstartup \
    PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin \
    VNC_RES=1920x1080 \
    VNC_PW=12345678 \
    KASM_VNC_PORT=6901

# Add our custom startup script
COPY start.sh /dockerstartup/start.sh
RUN chmod +x /dockerstartup/start.sh

# Install core packages for KasmVNC and a minimal X server
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    xserver-xorg-video-dummy \
    xserver-xorg-input-void \
    xserver-xorg-input-all \
    x11-utils \
    locales \
    dbus-x11 \
    sudo \
    curl \
    nano \
    # Needed for KasmVNC for a smoother experience
    mesa-utils \
    libvulkan1 \
    vulkan-tools \
    # Base packages for KDE, minimal install
    sddm \
    task-kde-desktop \
    # Clean up APT cache
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Generate locales
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8

# Install KasmVNC - using the official Kasm repo
# This is much faster than compiling
RUN curl -fsSL https://kasmweb.com/kasm_release.gpg | gpg --dearmor | tee /etc/apt/trusted.gpg.d/kasm_release.gpg > /dev/null && \
    echo "deb [arch=amd64] https://kasmweb.com/c/debian trixie main" | tee /etc/apt/sources.list.d/kasm_release.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends kasmvnc \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Optimize KDE for VNC (disable compositing)
COPY optimize_kde.sh /dockerstartup/optimize_kde.sh
RUN chmod +x /dockerstartup/optimize_kde.sh
RUN /dockerstartup/optimize_kde.sh

# Expose KasmVNC port
EXPOSE 6901

# Set the entrypoint to our startup script
ENTRYPOINT ["/dockerstartup/start.sh"]
