{ lib, config, ... }:
with lib;
let
  cfg = config.docs;
in
{
  options.docs.enable = mkEnableOption "docs";

  config.os.documentation = mkIf cfg.enable {
    dev.enable = true;
    nixos.includeAllModules = true;
  };
}
