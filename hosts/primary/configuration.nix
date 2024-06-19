{
  inputs,
  pkgs,
  lib,
  config,
  ...
}:
{
  imports = [ ./hardware-configuration.nix ];

  system.stateVersion = "23.11"; # Read the docs before changing

  impermanence.disk = "nvme0n1";

  homeManager.module = ./home.nix;

  environment.systemPackages = with pkgs; [
    git
    neovim
    fzf
    (import ../../scripts/build-installer.nix pkgs)
    (import ../../scripts/write-installer.nix pkgs)
  ];

  # TODO: Needed? systemd.tmpfiles.rules = [ "d /persist/home 0700 noah users -" ];

  users.users.noah = {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
  };

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "noah" ];
}
