{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.anyrun;
in
{
  inputs.anyrun.url = "github:anyrun-org/anyrun";

  hmImports = [ inputs.anyrun.homeManagerModules.default ];

  options.anyrun.enable = mkEnableOption "docs";

  config = mkIf cfg.enable {
    os.nix.settings = {
      substituters = [ "https://anyrun.cachix.org" ];
      trusted-public-keys = [ "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s=" ];
    };

    hm.programs.anyrun = {
      enable = true;
      config.plugins = [ inputs.anyrun.packages.${pkgs.system}.applications ];
    };
  };
}
