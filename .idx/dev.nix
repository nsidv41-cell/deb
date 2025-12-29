{ pkgs, ... }: {
  channel = "stable-24.11"; # Latest NixOS stable channel (equivalent to Debian 13 tooling)
  packages = [
    pkgs.docker           # Install Docker
    pkgs.git              # Install Git for cloning
    pkgs.qemu_kvm         # Include QEMU with KVM support for potential nested VMs
  ];

  # Enable and configure the Docker service
  services.docker.enable = true;

  # Configure IDX previews (port forwarding)
  idx.
