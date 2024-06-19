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

  # TODO: Needed? systemd.tmpfiles.rules = [ "d /persist/home 0700 noah users -" ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "noah" ];
}
