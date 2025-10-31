{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  options.cli.rb.enable = lib.mkEnableOption "the custom NixOS rebuild command";

  config.hm.home.packages = lib.mkIf config.cli.rb.enable [(pkgs.writeShellScriptBin "rb" "${lib.getExe inputs.modulix.packages.${pkgs.stdenv.system}.mxg} && ${lib.getExe pkgs.nh} os $* /etc/nixos")];
}
