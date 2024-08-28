{
  lib,
  config,
  ...
}:
with lib; {
  imports = [
    ./core
    ./cli
    ./desktop
    ./apps
    ./documentation.nix
  ];

  core.enable = mkDefault true;
  cli.enable = mkDefault true;
  desktop.enable = mkDefault true;
  apps.enable = mkIf config.desktop.enable (mkDefault true);
  documentation.enable = mkDefault true;
}
