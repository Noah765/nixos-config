{
  lib,
  config,
  ...
}: {
  options.desktop.hyprsunset.enable = lib.mkEnableOption "Hyprsunset";

  config = lib.mkIf config.desktop.hyprsunset.enable {
    dependencies = ["desktop.hyprland"];

    hm.services.hyprsunset.enable = true;
    hm.services.hyprsunset.settings.profile = [
      {time = "7:30";}
      {
        time = "17:00";
        temperature = 5500;
        gamma = 0.9;
      }
      {
        time = "18:00";
        temperature = 5000;
        gamma = 0.8;
      }
      {
        time = "19:00";
        temperature = 4500;
        gamma = 0.7;
      }
      {
        time = "20:00";
        temperature = 4000;
        gamma = 0.6;
      }
    ];
  };
}
