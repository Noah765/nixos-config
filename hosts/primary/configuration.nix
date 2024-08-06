{...}: {
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "primary";
    nvidia.enable = true;
    ddcutil.enable = true;
  };

  cli.installer.enable = true;

  desktop.hyprland.settings.monitor = [
    "DP-1, 1920x1080@144, 0x0, 1"
    "HDMI-A-1, 1920x1080@75, 1920x0, 1"
  ];
}
