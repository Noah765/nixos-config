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
    ./boot.nix
    ./nvidia.nix
    ./user.nix
    ./yubikey.nix
    ./agenix.nix
    ./network-manager.nix
    ./time-zone.nix
    ./keyboard.nix
  ];

  options.core.enable = mkEnableOption "core programs and services needed for a working NixOS system";

  config.core = mkIf cfg.enable {
    nix.enable = mkDefault true;
    impermanence.enable = mkDefault true;
    boot.enable = mkDefault true;
    user.enable = mkDefault true;
    yubikey.enable = mkDefault true;
    agenix.enable = mkDefault true;
    networkmanager.enable = mkDefault true;
    timeZone.enable = mkDefault true;
    keyboard.enable = mkDefault true;
  };
}
