{...}: {
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "";
    networkmanager.hostName = "laptop";
  };

  cli.installer.enable = true;

  desktop.hyprland.settings.monitor = [];
}
