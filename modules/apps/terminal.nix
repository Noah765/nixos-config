{
  lib,
  config,
  ...
}: {
  options.apps.terminal.enable = lib.mkEnableOption "Kitty";

  config = lib.mkIf config.apps.terminal.enable {
    hm.programs.kitty = {
      enable = true;

      settings = {
        # TODO reevaluate these
        url_style = "straight";
        enable_audio_bell = "no";
        visual_bell_duration = 0.2; # TODO Test different durations and easing functions
        remember_window_size = "no";
        initial_window_width = "70c";
        initial_window_height = "30c";
        enabled_layouts = "splits";
        tab_bar_edge = "top";
        tab_bar_style = "custom";
        active_tab_font_style = "normal";
      };

      keybindings = {
        "alt+r" = "launch --cwd=current --location=vsplit";
        "alt+s" = "launch --cwd=current --location=hsplit";
        "alt+t" = "launch --cwd=current --type=tab";

        "alt+h" = "previous_tab";
        "alt+l" = "next_tab";
        "alt+1" = "goto_tab 1";
        "alt+2" = "goto_tab 2";
        "alt+3" = "goto_tab 3";
        "alt+4" = "goto_tab 4";
        "alt+5" = "goto_tab 5";
        "alt+6" = "goto_tab 6";
        "alt+7" = "goto_tab 7";
        "alt+8" = "goto_tab 8";
        "alt+9" = "goto_tab 9";
        "alt+0" = "goto_tab 0";

        "alt+shift+h" = "move_window left";
        "alt+shift+j" = "move_window down";
        "alt+shift+k" = "move_window up";
        "alt+shift+l" = "move_window right";

        "alt+ctrl+shift+h" = "move_tab_backward";
        "alt+ctrl+shift+l" = "move_tab_forward";

        "alt+q" = "close_window";
      };
    };

    # TODO Improve / clean up
    hm.xdg.configFile."kitty/tab_bar.py".text = ''
      from kitty.fast_data_types import Screen
      from kitty.tab_bar import DrawData, ExtraData, TabBarData, as_rgb, draw_title

      def draw_tab(
        draw_data: DrawData, screen: Screen, tab: TabBarData,
        before: int, max_tab_length: int, index: int, is_last: bool,
        extra_data: ExtraData
      ) -> int:
        screen.draw(' ')
        draw_title(draw_data, screen, tab, index, max_tab_length)
        screen.draw(' ')
        if is_last:
          screen.draw(' ' * (screen.columns - screen.cursor.x))
        return screen.cursor.x
    '';

    desktop.hyprland.settings.bind = ["Super, T, exec, kitty"];
  };
}
