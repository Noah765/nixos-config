{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.dev.rust.enable = mkEnableOption "Rust";

  config.core.impermanence.hm.directories = mkIf config.dev.rust.enable [".cargo" ".rustup"];
}
