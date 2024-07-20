{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.firefox;
in {
  options.firefox.enable = mkEnableOption "firefox";

  config = mkIf cfg.enable {
    hm.programs.firefox = {
      enable = true;
      profiles.noah = {};
    };

    impermanence.hm.directories = [".mozilla/firefox/noah"];
  };
}
