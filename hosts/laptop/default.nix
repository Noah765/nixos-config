{
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    keyboard.enable = true;
    networkmanager.hostName = "laptop";
  };

  apps.steam.enable = true;

  cli.installer.enable = true;

  dev.flutter.enable = true;
}
