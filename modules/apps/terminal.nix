{
  lib,
  config,
  ...
}: {
  options.apps.terminal.enable = lib.mkEnableOption "Kitty";

  config = lib.mkIf config.apps.terminal.enable {
    hm.programs.kitty = {
      enable = true;

      settings = with config.theme.colors; {
        font_size = config.theme.fonts.size;

        inherit foreground background;
        selection_foreground =
          if selectionForeground == null
          then "none"
          else selectionForeground;
        selection_background = selectionBackground;

        cursor = foreground;
        cursor_text_color = background;

        #url_color = url;
        url_style = "straight";

        enable_audio_bell = "no";
        visual_bell_duration = 0.2; # TODO Test different durations and easing functions
        # bell_border_color = urgent; # TODO Maybe change

        remember_window_size = "no";
        initial_window_width = "70c";
        initial_window_height = "30c";
        enabled_layouts = "splits";
        active_border_color = activeWindowBorder;
        inactive_border_color = inactiveWindowBorder;
        tab_bar_edge = "top";
        tab_bar_style = "custom";
        active_tab_foreground = activeTabForeground;
        active_tab_background = activeTabBackground;
        active_tab_font_style = "normal";
        inactive_tab_foreground = inactiveTabForeground;
        inactive_tab_background = inactiveTabBackground;

        color0 = terminal0;
        color1 = terminal1;
        color2 = terminal2;
        color3 = terminal3;
        color4 = terminal4;
        color5 = terminal5;
        color6 = terminal6;
        color7 = terminal7;
        color8 = terminal8;
        color9 = terminal9;
        color10 = terminal10;
        color11 = terminal11;
        color12 = terminal12;
        color13 = terminal13;
        color14 = terminal14;
        color15 = terminal15;

        allow_remote_control = "password";
        remote_control_password = "password kitten focus-window"; # TODO Generate a password
      };

      keybindings = {
        # Set up control-shift-key mappings for neovim
        "ctrl+shift+h" = "send_text all \\x1b[72;5u";
        "ctrl+shift+j" = "send_text all \\x1b[74;5u";
        "ctrl+shift+k" = "send_text all \\x1b[75;5u";
        "ctrl+shift+l" = "send_text all \\x1b[76;5u";

        "alt+r" = "launch --cwd=current --location=vsplit";
        "alt+s" = "launch --cwd=current --location=hsplit";
        "alt+t" = "launch --cwd=current --type=tab";

        "ctrl+h" = "kitten pass_keys.py left ctrl+h";
        "ctrl+j" = "kitten pass_keys.py bottom ctrl+j";
        "ctrl+k" = "kitten pass_keys.py top ctrl+k";
        "ctrl+l" = "kitten pass_keys.py right ctrl+l";

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
          screen.cursor.bg = as_rgb(0x${lib.removePrefix "#" config.theme.colors.tabLineBackground})
          screen.draw(' ' * (screen.columns - screen.cursor.x))
        return screen.cursor.x
    '';

    desktop.hyprland.settings.bind = ["Super, T, exec, kitty"];
  };
}
