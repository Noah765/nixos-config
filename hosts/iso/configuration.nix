{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  osImports = [
    ({modulesPath, ...}: {
      imports = ["${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix"];
      nixpkgs.hostPlatform.system = "x86_64-linux";
    })
  ];

  hmUsername = "nixos";

  impermanence.enable = false;
  networkmanager.hostName = "nixos";
  user.enable = false;
  desktop.enable = false;

  os.isoImage.makeBiosBootable = false; # Make sure the firmware for an EFI install is available

  hm.home.packages = with pkgs; [
    (import ./wifiScript.nix pkgs)
    (import ./downloadScript.nix pkgs)
    (import ./generateScript.nix pkgs)
    (import ./installScript.nix pkgs)
    # TODO Provide these in separate modules
    disko
    fzf
  ];
}
