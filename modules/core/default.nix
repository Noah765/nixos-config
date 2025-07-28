{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./boot.nix
    ./charachorder.nix
    ./impermanence.nix
    ./keyboard.nix
    ./network-manager.nix
    ./nix.nix
    ./nvidia.nix
    ./secrets.nix
    ./time-zone.nix
    ./user.nix
  ];

  options.core.enable = mkEnableOption "core programs and services needed for a working NixOS system";

  config.core = mkIf config.core.enable {
    boot.enable = mkDefault true;
    impermanence.enable = mkDefault true;
    networkmanager.enable = mkDefault true;
    nix.enable = mkDefault true;
    secrets.enable = mkDefault true;
    timeZone.enable = mkDefault true;
    user.enable = mkDefault true;
  };
}
