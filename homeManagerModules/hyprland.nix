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
    settings = options.wayland.windowManager.hyprland.settings;
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

      settings = {
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

        animations = { }; # TODO

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

        monitor = [
          ", highres, auto, 1"
          "Unknown-1, disable"
        ];

        bindm = [
          "Super, mouse:272, movewindow"
          "Super, mouse:273, resizewindow"
        ];

        # TODO Binding multiple normal keys doesn't seem to be supported. Find a workaround (using submaps, maybe use https://github.com/hyprland-community/hyprnix to make them easier to configure in nix?)

        binde = [
          "Super+R, Up, resizeactive, 0 -100"
          "Super+R, Right, resizeactive, 100 0"
          "Super+R, Down, resizeactive, 0 100"
          "Super+R, Left, resizeactive, -100 0"
        ];

        bind = [
          "Super, R, scroller:setmode, row"
          "Super, C, scroller:setmode, col"

          "Super, Up, scroller:movefocus, u"
          "Super, Right, scroller:movefocus, r"
          "Super, Down, scroller:movefocus, d"
          "Super, Left, scroller:movefocus, l"
          "Super, Home, scroller:movefocus, begin"
          "Super, End, scroller:movefocus, end"

          "Super+Shift, Up, scroller:movewindow, u"
          "Super+Shift, Right, scroller:movewindow, r"
          "Super+Shift, Down, scroller:movewindow, d"
          "Super+Shift, Left, scroller:movewindow, l"
          "Super+Shift, Home, scroller:movewindow, begin"
          "Super+Shift, End, scroller:movewindow, end"
          "Super+Shift, L, scroller:admitwindow"
          "Super+Shift, R, scroller:expelwindow"

          "Super+A, C, scroller:alignwindow, c"
          "Super+A, Up, scroller:alignwindow, u"
          "Super+A, Right, scroller:alignwindow, r"
          "Super+A, Down, scroller:alignwindow, d"
          "Super+A, Left, scroller:alignwindow, l"

          "Super, Minus, scroller:cyclesize, prev"
          "Super, Plus, scroller:cyclesize, next"
          "Super+F, V, scroller:fitsize, visible"
          "Super+F, Up, scroller:fitsize, active"
          "Super+F, Right, scroller:fitsize, toend"
          "Super+F, Down, scroller:fitsize, all"
          "Super+F, Left, scroller:fitsize, tobeg"

          "Super, Q, killactive"

          "Super, T, exec, kitty"
        ];
      } // cfg.settings;
    };
  };
}
