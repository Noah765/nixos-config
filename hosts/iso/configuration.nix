{
  modulesPath,
  pkgs,
  config,
  ...
}:
{
  imports = [ /${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix ];

  nixpkgs.hostPlatform = "x86_64-linux";

  impermanence.disk = "";
  homeManager.enable = false;

  isoImage.makeBiosBootable = false; # Make sure the firmware for an EFI install is available
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ]; # Tp-link wifi driver
  networking = {
    wireless.enable = false;
    networkmanager.enable = true;
  };

  environment.systemPackages = with pkgs; [
    git
    disko
    neovim
    fzf
    nixfmt-rfc-style
    (import ./wifi-script.nix pkgs)
    (import ./download-script.nix pkgs)
    (import ./generate-script.nix pkgs)
    (import ./install-script.nix pkgs)
  ];
}
