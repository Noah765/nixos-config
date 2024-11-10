{
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "laptop";
  };

  cli.installer.enable = true;

  # TODO
  desktop.hyprland.settings.monitor = [];

  dev = {
    unity.enable = true;
    flutter.enable = true;
  };
}
