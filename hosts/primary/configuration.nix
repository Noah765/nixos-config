{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  impermanence.disk = "nvme0n1";
  nvidia.enable = true;
  homeManager.module = ./home.nix;
  hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    fzf
    kitty
  ];
}
