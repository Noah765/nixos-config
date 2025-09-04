{
  lib,
  config,
  ...
}: {
  imports = [
    ./apps
    ./cli
    ./core
    ./dependencies.nix
    ./desktop
    ./dev
    ./documentation.nix
    ./theme
  ];

  apps.enable = lib.mkIf config.desktop.enable (lib.mkDefault true);
  cli.enable = lib.mkDefault true;
  core.enable = lib.mkDefault true;
  desktop.enable = lib.mkDefault true;
  dev.enable = lib.mkDefault true;
  documentation.enable = lib.mkDefault true;
}
