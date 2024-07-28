{pkgs, ...}: {
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "primary";
    nvidia.enable = true;
  };

  cli.installer.enable = true;

  desktop.hyprland.settings.monitor = [
    "DP-1, 1920x1080@144, 0x0, 1"
    "HDMI-A-1, 1920x1080@75, 1920x0, 1"
  ];

  os = {
    virtualisation.virtualbox.host.enable = true;
    users.extraGroups.vboxusers.members = ["noah"];
  };
  core.impermanence.hm.directories = ["VirtualBox VMs"];

  hm.home.packages = [pkgs.disko];
}
