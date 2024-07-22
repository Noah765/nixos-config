{pkgs, ...}: {
  osImports = [./hardware-configuration.nix];

  impermanence.disk = "nvme0n1";
  networking.hostName = "primary";
  nvidia.enable = true;
  hyprland.settings.monitor = [
    "DP-1, 1920x1080@144, 0x0, 1"
    "HDMI-A-1, 1920x1080@75, 1920x0, 1"
  ];
  installer.enable = true;
}
