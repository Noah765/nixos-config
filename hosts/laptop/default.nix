{inputs, ...}: {
  osImports = [./hardware-configuration.nix inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t490];

  core = {
    impermanence.disk = "nvme0n1";
    keyboard.enable = true;
    networking.hostName = "laptop";
  };

  apps.steam.enable = true;
  apps.signal.enable = true;

  cli.installer.enable = true;

  dev = {
    dart.enable = true;
    java.enable = true;
    nu.enable = true;
    qml.enable = true;
    rust.enable = true;
    typst.enable = true;
  };
}
