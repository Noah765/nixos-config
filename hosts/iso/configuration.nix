{
  modulesPath,
  pkgs,
  config,
  ...
}:
{
  imports = [
   /${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix
    ../../nixosModules/localization.nix
  ];

  nixpkgs.hostPlatform = "x86_64-linux";

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  
  boot.extraModulePackages = [ config.boot.kernelPackages.rtl88x2bu ];
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
