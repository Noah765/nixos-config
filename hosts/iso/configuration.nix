{
  #modulesPath,
  #pkgs,
  #config,
  ...
}:
{
  #imports = [
  #  /${modulesPath}/installer/cd-dvd/installation-cd-minimal.nix
  #  ./wifiScript.nix
  #  ./downloadScript.nix
  #  ./generateScript.nix
  #  ./installScript.nix
  #];

  #nixpkgs.hostPlatform = "x86_64-linux";

  #impermanence.enable = false;
  #user.enable = false;
  #homeManager.enable = false;

  #isoImage.makeBiosBootable = false; # Make sure the firmware for an EFI install is available

  #environment.systemPackages = with pkgs; [
  #  git
  #  disko
  #  neovim
  #  fzf
  #  nixfmt-rfc-style
  #];
}
