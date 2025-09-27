{
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    keyboard.enable = true;
    networkmanager.hostName = "laptop";
  };

  apps.steam.enable = true;
  apps.signal.enable = true;

  cli.installer.enable = true;

  dev = {
    flutter.enable = true;
    java.enable = true;
    typst.enable = true;
  };
}
