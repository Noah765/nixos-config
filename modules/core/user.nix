{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.core.user;
in {
  options.core.user = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to create a user account called noah.";
    };

    groups = mkOption {
      type = with types; listOf str;
      default = [];
      description = "The user's auxiliary groups.";
    };
  };

  config = mkIf cfg.enable {
    os.users.users.noah = {
      isNormalUser = true;
      initialPassword = "12345";
      extraGroups = ["wheel"] ++ cfg.groups;
    };

    hmUsername = "noah";
  };
}
