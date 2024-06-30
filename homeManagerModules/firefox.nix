{ lib, config, ... }:
with lib;
let
  cfg = config.firefox;
in
{
  options.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.noah = { };
    };

    impermanence.directories = [ ".mozilla/firefox/noah" ];
  };
}
