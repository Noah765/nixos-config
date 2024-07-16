{ lib, config, ... }:
with lib;
let
  cfg = config.networking;
in
{
  options.networking = {
    enable = mkEnableOption "networking";
    hostName = mkOption {
      type = types.str;
      description = "The name of the machine.";
    };
  };

  config = mkIf cfg.enable {
    os.networking = {
      wireless.enable = false; # The iso config has this enabled by default
      hostName = cfg.hostName;
      networkmanager.enable = true;
    };
    user.groups = [ "networkmanager" ];
    impermanence.os.directories = [ "/etc/NetworkManager/system-connections" ];
  };
}
