{ lib, config, ... }:
with lib;
let
  cfg = config.user;
in
{
  options.user = {
    enable = mkEnableOption "user";
    groups = mkOption {
      # TODO
    };
  };

  config = mkIf cfg.enable {
    # TODO
  };
}
