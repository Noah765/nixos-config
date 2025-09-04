{
  lib,
  config,
  ...
}: {
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

  options.core.enable = lib.mkEnableOption "core programs and services needed for a working NixOS system";

  config.core = lib.mkIf config.core.enable {
    boot.enable = lib.mkDefault true;
    impermanence.enable = lib.mkDefault true;
    networkmanager.enable = lib.mkDefault true;
    nix.enable = lib.mkDefault true;
    secrets.enable = lib.mkDefault true;
    timeZone.enable = lib.mkDefault true;
    user.enable = lib.mkDefault true;
  };
}
