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

  hmUsername = mkForce "nixos";

  impermanence.enable = false;
  networking.hostName = "nixos";

  os = {
    isoImage.makeBiosBootable = false; # Make sure the firmware for an EFI install is available

    environment.systemPackages = with pkgs; [
      (import ./wifiScript.nix pkgs)
      (import ./downloadScript.nix pkgs)
      (import ./generateScript.nix pkgs)
      (import ./installScript.nix pkgs)
      git
      disko
      neovim
      fzf
      nixfmt-rfc-style
    ];
  };
}
