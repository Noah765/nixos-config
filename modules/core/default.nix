{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core;
in {
  imports = [
    ./nix.nix
    ./impermanence.nix
    ./systemd-boot.nix
    ./network-manager.nix
    ./pulseaudio.nix
    ./nvidia.nix
    ./ddcutil.nix
    ./user.nix
  ];

  options.core.enable = mkEnableOption "core programs and services needed for a working NixOS system";

  config.core = mkIf cfg.enable {
    nix.enable = mkDefault true;
    impermanence.enable = mkDefault true;
    systemd-boot.enable = mkDefault true;
    networkmanager.enable = mkDefault true;
    pulseaudio.enable = mkDefault true;
    user.enable = mkDefault true;
  };
}
