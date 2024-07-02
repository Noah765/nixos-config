{
  inputs,
  pkgs,
  osConfig,
  lib,
  options,
  config,
  ...
}:
with lib;
let
  cfg = config.hyprland;
in
{
  imports = [ inputs.hyprnix.homeManagerModules.default ];

  options.hyprland = {
    enable = mkEnableOption "hyprland";
    config = options.wayland.windowManager.hyprland.config;
    monitors = options.wayland.windowManager.hyprland.monitors // {
      default.default = {
        name = "";
        resolution = "highres";
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = osConfig.hyprland.enable;
        message = "The NixOS hyprland module is required for the home manager hyprland module.";
      }
    ];

    home.sessionVariables.NIXOS_OZONE_WL = 1;

    wayland.windowManager.hyprland = {
      enable = true;

      plugins = [ inputs.hyprscroller.packages.${pkgs.system}.default ];

      config = {
        general = {
          gaps_in = 2;
          gaps_out = 5;
          layout = "scroller";
          no_focus_fallback = true;
          resize_on_border = true;
          # TODO allow_tearing
        };

        decoration = {
          rounding = 12;
          # TODO shadows
          # TODO dimming
          # TODO blur
        };

        # These values are taken from end-4's config
        animations = {
          bezier = [
            "md3_decel, 0.05, 0.7, 0.1, 1"
            "md3_accel, 0.3, 0, 0.8, 0.15"
            "menu_decel, 0.1, 1, 0, 1"
            "menu_accel, 0.38, 0.04, 1, 0.07"
          ];

          animation = [
            "windows, 1, 3, md3_decel, popin 60%"
            "windowsOut, 1, 3, md3_accel, popin 60%"
            "layersIn, 1, 3, menu_decel, slide"
            "layersOut, 1, 1.6, menu_accel"
            "fade, 1, 3, md3_decel"
            "fadeLayersIn, 1, 2, menu_decel"
            "fadeLayersOut, 1, 4.5, menu_accel"
            "border, 1, 10, default"
            "workspaces, 1, 7, menu_decel, slide"
            "specialWorkspace, 1, 3, md3_decel, slidevert"
          ];
        };

        input = {
          repeat_rate = 35;
          repeat_delay = 250;
          special_fallthrough = true;
        };

        # TODO groups (configure the layout first)

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          # TODO vrr
          disable_autoreload = true;
          enable_swallow = true;
          swallow_regex = "^${config.home.sessionVariables.TERMINAL}$";
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          # TODO initial_workspace_tracking
        };

        binds = {
          scroll_event_delay = 0;
          # TODO workspace settings
          # TODO focus_preferred_method
        };

        cursor = {
          # TODO persistent_warps
          # TODO warp_on_change_workspace
        };

        monitor = [ "Unknown-1, disable" ];
      } // cfg.config;

      monitors = cfg.monitors;

      keyBinds = {
        bind."Super, Y" = "scroller:setmode, row";
        bind."Super, X" = "scroller:setmode, col";

        bind."Super, Up" = "scroller:movefocus, u";
        bind."Super, Right" = "scroller:movefocus, r";
        bind."Super, Down" = "scroller:movefocus, d";
        bind."Super, Left" = "scroller:movefocus, l";
        bind."Super, Home" = "scroller:movefocus, begin";
        bind."Super, End" = "scroller:movefocus, end";

        bind."Super+Ctrl, A" = "scroller:marksadd, a";
        bind."Super+Ctrl, S" = "scroller:marksadd, s";
        bind."Super+Ctrl, D" = "scroller:marksadd, d";
        bind."Super, A" = "scroller:marksvisit, a";
        bind."Super, S" = "scroller:marksvisit, s";
        bind."Super, D" = "scroller:marksvisit, d";

        bind."Super+Shift, Up" = "scroller:movewindow, u";
        bind."Super+Shift, Right" = "scroller:movewindow, r";
        bind."Super+Shift, Down" = "scroller:movewindow, d";
        bind."Super+Shift, Left" = "scroller:movewindow, l";
        bind."Super+Shift, Home" = "scroller:movewindow, begin";
        bind."Super+Shift, End" = "scroller:movewindow, end";
        bind."Super+Shift, L" = "scroller:admitwindow";
        bind."Super+Shift, R" = "scroller:expelwindow";
        bindm."Super, mouse:272" = "movewindow"; # TODO Keep?

        bind."Super+Shift+Ctrl, C" = "scroller:alignwindow, c";
        bind."Super+Shift+Ctrl, Up" = "scroller:alignwindow, u";
        bind."Super+Shift+Ctrl, Right" = "scroller:alignwindow, r";
        bind."Super+Shift+Ctrl, Down" = "scroller:alignwindow, d";
        bind."Super+Shift+Ctrl, Left" = "scroller:alignwindow, l";

        bind."Super, Minus" = "scroller:cyclesize, prev";
        bind."Super, Plus" = "scroller:cyclesize, next";
        binde."Super+Alt+Ctrl, Up" = "resizeactive, 0 -100";
        binde."Super+Alt+Ctrl, Right" = "resizeactive, 100 0";
        binde."Super+Alt+Ctrl, Down" = "resizeactive, 0 100";
        binde."Super+Alt+Ctrl, Left" = "resizeactive, -100 0";
        bindm."Super, mouse:273" = "resizewindow"; # TODO Keep?
        bind."Super, F" = "fullscreen, 0";
        bind."Super, G" = "fullscreen, 1";

        bind."Super+Alt, V" = "scroller:fitsize, visible";
        bind."Super+Alt, Up" = "scroller:fitsize, active";
        bind."Super+Alt, Right" = "scroller:fitsize, toend";
        bind."Super+Alt, Down" = "scroller:fitsize, all";
        bind."Super+Alt, Left" = "scroller:fitsize, tobeg";

        bind."Super, O" = "togglefloating";
        bind."Super, P" = "pin";

        bind."Super, Tab" = "scroller:toggleoverview"; # TODO Resize overview, or use other overview options like hyprexpo

        bind."Super, 1" = "focusworkspaceoncurrentmonitor, 1";
        bind."Super, 2" = "focusworkspaceoncurrentmonitor, 2";
        bind."Super, 3" = "focusworkspaceoncurrentmonitor, 3";
        bind."Super, 4" = "focusworkspaceoncurrentmonitor, 4";
        bind."Super, 5" = "focusworkspaceoncurrentmonitor, 5";
        bind."Super, 6" = "focusworkspaceoncurrentmonitor, 6";
        bind."Super, 7" = "focusworkspaceoncurrentmonitor, 7";
        bind."Super, 8" = "focusworkspaceoncurrentmonitor, 8";
        bind."Super, 9" = "focusworkspaceoncurrentmonitor, 9";
        bind."Super, 0" = "focusworkspaceoncurrentmonitor, 10";

        bind."Super+Shift, 1" = "movetoworkspacesilent, 1";
        bind."Super+Shift, 2" = "movetoworkspacesilent, 2";
        bind."Super+Shift, 3" = "movetoworkspacesilent, 3";
        bind."Super+Shift, 4" = "movetoworkspacesilent, 4";
        bind."Super+Shift, 5" = "movetoworkspacesilent, 5";
        bind."Super+Shift, 6" = "movetoworkspacesilent, 6";
        bind."Super+Shift, 7" = "movetoworkspacesilent, 7";
        bind."Super+Shift, 8" = "movetoworkspacesilent, 8";
        bind."Super+Shift, 9" = "movetoworkspacesilent, 9";
        bind."Super+Shift, 0" = "movetoworkspacesilent, 0";

        bind."Super, Q" = "killactive";

        bind."Super, T" = "exec, kitty";
      };
    };
  };
}
