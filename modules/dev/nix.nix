{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.nix.enable = lib.mkEnableOption "Nix development tools";

  config.hm.home.packages = lib.mkIf config.dev.nix.enable (with pkgs; [alejandra statix deadnix]);
}
