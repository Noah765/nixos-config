{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.cli.nix;
in {
  options.cli.nix.enable = mkEnableOption "useful utilities when working with Nix";

  config = mkIf cfg.enable {
    os.programs.nh = {
      enable = true;
      flake = "/etc/nixos";
    };

    hm.home.packages = [pkgs.nix-output-monitor];
  };
}
