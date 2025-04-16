{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkOption;
  cfg = config.core.networkmanager;
in {
  options.core.networkmanager = {
    enable = mkEnableOption "NetworkManager";
    hostName = mkOption {
      type = lib.types.str;
      description = "The name of the machine.";
    };
  };

  config = mkIf cfg.enable {
    os.networking = {
      wireless.enable = false; # The iso config has this enabled by default
      hostName = cfg.hostName;
      networkmanager.enable = true;
    };
    core.user.groups = ["networkmanager"];
    core.impermanence.os.directories = ["/etc/NetworkManager/system-connections"];
  };
}
