{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  options.cli.rb.enable = lib.mkEnableOption "the custom NixOS rebuild command";

  config.hm.home.packages = lib.mkIf config.cli.rb.enable (lib.singleton (pkgs.writers.writeNuBin "rb" ''
    def --wrapped main [...args] {
      if ($args | is-empty) { ${lib.getExe pkgs.nh} os }
      ${lib.getExe inputs.modulix.packages.${pkgs.stdenv.system}.mxg}
      ${lib.getExe pkgs.nh} os $args.0 /etc/nixos ...($args | skip 1)
    }
  ''));
}
