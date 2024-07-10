{ lib, config, ... }:
with lib;
let
  cfg = config.networking;
in
{
  options.networking.enable = mkEnableOption "networking";

  config = mkIf cfg.enable {
    os.networking = {
      wireless.enable = false; # The iso config has this enabled by default
      hostName = "noah";
      networkmanager.enable = true;
    };
    user.groups = [ "networkmanager" ];
    # TODO impermanence.directories = [ "/etc/NetworkManager/system-connections" ];
  };
}
