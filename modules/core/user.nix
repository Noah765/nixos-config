{lib, ...}: {
  nixos = {config, ...}: {
    options.core.user.enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to create a user account called noah.";
    };
    options.core.user.groups = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "The user's auxiliary groups.";
    };

    config.users = lib.mkIf config.core.user.enable {
      mutableUsers = false;

      users.noah = {
        isNormalUser = true;
        initialPassword = "12345";
        extraGroups = ["wheel"] ++ config.core.user.groups;
      };
    };
  };
}
