{ pkgs, ... }: {
  # 1. Use a standard channel (errors often happen if this is wrong)
  channel = "stable-24.11"; 

  # 2. Package list (ensure no trailing commas inside brackets)
  packages = [
    pkgs.docker
    pkgs.git
    pkgs.qemu_kvm
  ];

  # 3. Docker Service (This must be OUTSIDE the 'idx' block)
  services.docker.enable = true;

  # 4. The 'idx' block for previews and extensions
  idx = {
    extensions = [
      "ms-azuretools.vscode-docker"
    ];

    previews = {
      enable = true;
      previews = {
        # The key should be a name like 'kde-desktop'
        kde-desktop = {
          # Use $PORT variable; IDX handles the routing automatically
          command = [
            "docker" "run" "--rm" "--privileged" "--device=/dev/kvm" 
            "-p" "$PORT:6901" "debian13-kde-kasm"
          ];
          manager = "web";
        };
      };
    };
  };
}
