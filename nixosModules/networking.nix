{ lib, config, ... }:
with lib;
let
  cfg = config.networking;
in
{
  options.networking.enable = mkEnableOption "networking";

  config = mkIf cfg.enable {
    networking = {
      hostName = "noah";
      networkmanager.enable = true;
    };
  };
}
