{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.cli.nix.enable = mkEnableOption "useful utilities when working with Nix";

  config = mkIf config.cli.nix.enable {
    os.programs.nh = {
      enable = true;
      flake = "/etc/nixos";
    };

    hm.home.packages = [pkgs.nix-output-monitor];
  };
}
