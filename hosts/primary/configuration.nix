{ pkgs, ... }:
{
  osModules = [ ./hardware-configuration.nix ];

  impermanence.disk = "nvme0n1";
  #impermanence.os.directories = ["test"];
  #nvidia.enable = true;
  #homeManager.module = ./home.nix;
  #hyprland.enable = true;

  #environment.systemPackages = with pkgs; [
  #  neovim
  #  fzf
  #  nixfmt-rfc-style
  #];
}
