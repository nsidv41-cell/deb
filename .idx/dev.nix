{ pkgs, ... }: {
  channel = "stable-24.11"; 
  packages = [
    pkgs.android-tools
    pkgs.unzip
  ];

  # Enable Android Preview service
  idx.previews = {
    enable = true;
    previews = {
      # This 'android' preview creates a high-performance web stream of the emulator
      android-machine = {
        manager = "android";
        # We use a tablet-style resolution to make it feel more like a 'Desktop OS'
        # You can access this via the Preview tab or the Port URL
      };
    };
  };
}
