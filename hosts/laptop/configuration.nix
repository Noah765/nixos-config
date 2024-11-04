{pkgs, ...}: {
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "laptop";
  };

  cli.installer.enable = true;

  # TODO
  desktop.hyprland.settings.monitor = [];

  apps.unity.enable = true;

  hm.home.packages = [pkgs.flutter];
  core.impermanence.hm.directories = [".pub-cache"];
}
