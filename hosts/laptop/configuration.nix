{...}: {
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "laptop";
  };

  cli.installer.enable = true;

  desktop.hyprland.settings.monitor = [];
}
