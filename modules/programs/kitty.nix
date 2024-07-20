{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.kitty;
in {
  options.kitty.enable = mkEnableOption "kitty";

  config = mkIf cfg.enable {
    hm = {
      programs.kitty.enable = true;
      home.sessionVariables.TERMINAL = "kitty";
    };

    hyprland.settings = {
      bind = ["Super, T, exec, kitty"];

      windowrule = ["opaque, ^kitty$"];
    };
  };
}
