{
  lib,
  config,
  ...
}: {
  options.dev.rust.enable = lib.mkEnableOption "Rust";

  config.core.impermanence.hm.directories = lib.mkIf config.dev.rust.enable [".cargo" ".rustup"];
}
