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
    ./theme
  ];

  apps.enable = lib.mkIf config.desktop.enable (lib.mkDefault true);
  cli.enable = lib.mkDefault true;
  core.enable = lib.mkDefault true;
  desktop.enable = lib.mkDefault true;
  dev.enable = lib.mkDefault true;
}
