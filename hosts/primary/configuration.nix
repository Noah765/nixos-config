{ pkgs, ... }:
{
  imports = [ ./hardware-configuration.nix ];

  impermanence.disk = "nvme0n1";
  nvidia.enable = true;
  homeManager.module = ./home.nix;

  environment.systemPackages = with pkgs; [
    git
    neovim
    fzf
  ];
}
