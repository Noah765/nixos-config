{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.user;
in {
  options.core.user = {
    enable = mkEnableOption "user";
    groups = mkOption {
      type = with types; listOf str;
      default = [];
      description = "The user's auxiliary groups.";
    };
  };

  config.os.users.users.noah = mkIf cfg.enable {
    isNormalUser = true;
    initialPassword = "12345";
    extraGroups = ["wheel"] ++ cfg.groups;
  };
}
