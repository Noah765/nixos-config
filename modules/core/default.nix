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
    ./nvidia.nix
    ./user.nix
    ./yubikey.nix
    ./network-manager.nix
    ./time-zone.nix
    ./keyboard.nix
  ];

  options.core.enable = mkEnableOption "core programs and services needed for a working NixOS system";

  config.core = mkIf cfg.enable {
    nix.enable = mkDefault true;
    impermanence.enable = mkDefault true;
    systemd-boot.enable = mkDefault true;
    user.enable = mkDefault true;
    yubikey.enable = mkDefault true;
    networkmanager.enable = mkDefault true;
    timeZone.enable = mkDefault true;
    keyboard.enable = mkDefault true;
  };
}
