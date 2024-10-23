{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.apps.kitty;
in {
  options.apps.kitty.enable = mkEnableOption "Kitty";

  config = mkIf cfg.enable {
    hm.programs.kitty = {
      enable = true;
      #font = {}; # TODO
      #keybindings = {}; # TODO
      settings = with config.theme.colors; {
        inherit foreground background;
        background_opacity = config.theme.terminalOpacity;
        selection_foreground =
          if selectionForeground == null
          then "none"
          else selectionForeground;
        selection_background = selectionBackground;
        cursor = foreground;
        cursor_text_color = background;

        color0 = black;
        color1 = red;
        color2 = green;
        color3 = yellow;
        color4 = blue;
        color5 = magenta;
        color6 = cyan;
        color7 = white;
        color8 = black; # TODO Maybe change to a grey color?
        color9 = red;
        color10 = green;
        color11 = yellow;
        color12 = blue;
        color13 = magenta;
        color14 = cyan;
        color15 = white; # TODO Maybe change to a grey color?
      };
    };

    desktop.hyprland.settings = {
      misc.swallow_regex = "^kitty$";
      # TODO Remove
      bind = ["Super, T, exec, kitty" "Super, J, exec, ${getExe (pkgs.writeShellScriptBin "test" "${getExe pkgs.hyprpicker} > ~/test")}"];
    };
  };
}
