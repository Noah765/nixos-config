{ lib, config, ... }:
with lib;
let
  cfg = config.user;
in
{
  options.user = {
    enable = mkEnableOption "user";
    groups = mkOption { type = with types; listOf str; };
  };

  config = mkIf cfg.enable {
    users.users.noah = {
      isNormalUser = true;
      initialPassword = "12345";
      extraGroups = [ "wheel" ] ++ cfg.groups;
    };
  };
}
