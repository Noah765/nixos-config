{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.apps.kitty;
in {
  options.apps.kitty.enable = mkEnableOption "Kitty";

  config = mkIf cfg.enable {
    hm = {
      programs.kitty.enable = true;
      home.sessionVariables.TERMINAL = "kitty";
    };

    desktop.hyprland.settings = {
      bind = ["Super, T, exec, kitty"];
      windowrule = ["opaque, ^kitty$"];
    };
  };
}
