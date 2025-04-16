{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  imports = [
    ./dependencies.nix
    ./core
    ./cli
    ./desktop
    ./dev
    ./apps
    ./documentation.nix
    ./themes
  ];

  core.enable = mkDefault true;
  cli.enable = mkDefault true;
  desktop.enable = mkDefault true;
  apps.enable = mkIf config.desktop.enable (mkDefault true);
  documentation.enable = mkDefault true;
}
