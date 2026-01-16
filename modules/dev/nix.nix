{
  lib,
  pkgs,
  configName,
  config,
  ...
}: {
  options.dev.nix.enable = lib.mkEnableOption "Nix development tools";

  config.cli.editor = lib.mkIf config.dev.nix.enable {
    packages = [pkgs.nixd];
    languageServers.nixd.config.nixd.options.modulix.expr = "(builtins.getFlake \"/etc/nixos\").modulixConfigurations.${configName}.options";
  };
}
