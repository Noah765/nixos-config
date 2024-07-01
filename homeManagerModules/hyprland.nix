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
          gaps_in = 4;
          gaps_out = 5;
          layout = "scroller";
          no_focus_fallback = true;
          resize_on_border = true;
          # TODO allow_tearing
        };

        decoration = {
          rounding = 20;
          # TODO shadows
          # TODO dimming
          # TODO blur
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

        #  monitor = [ "Unknown-1, disable" ];
      } // cfg.config;

      animations = { }; # TODO

      monitors = cfg.monitors;

      keyBinds = {
        bind."Super, R" = "scroller:setmode, row";
        bind."Super, C" = "scroller:setmode, col";

        bind."Super, Up" = "scroller:movefocus, u";
        bind."Super, Right" = "scroller:movefocus, r";
        bind."Super, Down" = "scroller:movefocus, d";
        bind."Super, Left" = "scroller:movefocus, l";
        bind."Super, Home" = "scroller:movefocus, begin";
        bind."Super, End" = "scroller:movefocus, end";

        bind."Super+Shift, Up" = "scroller:movewindow, u";
        bind."Super+Shift, Right" = "scroller:movewindow, r";
        bind."Super+Shift, Down" = "scroller:movewindow, d";
        bind."Super+Shift, Left" = "scroller:movewindow, l";
        bind."Super+Shift, Home" = "scroller:movewindow, begin";
        bind."Super+Shift, End" = "scroller:movewindow, end";
        bind."Super+Shift, L" = "scroller:admitwindow";
        bind."Super+Shift, R" = "scroller:expelwindow";
        bindm."Super, mouse:272" = "movewindow";

        binds."Super_L, A&C" = "scroller:alignwindow, c";
        binds."Super_L, A&Up" = "scroller:alignwindow, u";
        binds."Super_L, A&Right" = "scroller:alignwindow, r";
        binds."Super_L, A&Down" = "scroller:alignwindow, d";
        binds."Super_L, A&Left" = "scroller:alignwindow, l";

        bind."Super, Minus" = "scroller:cyclesize, prev";
        bind."Super, Plus" = "scroller:cyclesize, next";
        bindes."Super_L, R&Up" = "resizeactive, 0 -100";
        bindes."Super_L, R&Right" = "resizeactive, 100 0";
        bindes."Super_L, R&Down" = "resizeactive, 0 100";
        bindes."Super_L, R&Left" = "resizeactive, -100 0";
        bindm."Super, mouse:273" = "resizewindow";
        binds."Super_L, F&V" = "scroller:fitsize, visible";
        binds."Super_L, F&Up" = "scroller:fitsize, active";
        binds."Super_L, F&Right" = "scroller:fitsize, toend";
        binds."Super_L, F&Down" = "scroller:fitsize, all";
        binds."Super_L, F&Left" = "scroller:fitsize, tobeg";

        bind."Super, Q" = "killactive";

        bind."Super, T" = "exec, kitty";
      };
    };
  };
}
