{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.cli.rb.enable = mkEnableOption "the custom NixOS rebuild command";

  config.hm.home.packages = mkIf config.cli.rb.enable [(pkgs.writeShellScriptBin "rb" "${lib.getExe inputs.modulix.packages.${pkgs.system}.mxg} && ${lib.getExe pkgs.nh} os $* /etc/nixos")];
}
