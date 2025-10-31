{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.nu.enable = lib.mkEnableOption "Nu";
  config.cli.editor.packages = lib.mkIf config.dev.nu.enable [pkgs.nushell];
}
