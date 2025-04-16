{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkIf;
in {
  imports = [
    ./apps
    ./cli
    ./core
    ./dependencies.nix
    ./desktop
    ./dev
    ./documentation.nix
    ./themes
  ];

  apps.enable = mkIf config.desktop.enable (mkDefault true);
  cli.enable = mkDefault true;
  core.enable = mkDefault true;
  desktop.enable = mkDefault true;
  documentation.enable = mkDefault true;
}
