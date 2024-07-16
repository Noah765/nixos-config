{
  lib,
  pkgs,
  hmOptions,
  config,
  hmConfig,
  ...
}:
with lib;
let
  cfg = config.hyprland;
in
{
  options.hyprland =
    let
      options = hmOptions.wayland.windowManager.hyprland;
    in
    {
      enable = mkEnableOption "hyprland";
      settings = hmOptions.wayland.windowManager.hyprland.settings;
    };

  config = mkIf cfg.enable {
    os.programs.hyprland.enable = true;

    hm.home.sessionVariables.NIXOS_OZONE_WL = 1;

    hm.wayland.windowManager.hyprland = {
      enable = true;

      plugins = [ pkgs.hyprlandPlugins.hy3 ];

      settings = attrsets.recursiveUpdate {
        general = {
          gaps_in = 2;
          gaps_out = 5;
          layout = "hy3";
          resize_on_border = true;
          # TODO allow_tearing
        };

        decoration = {
          rounding = 12;

          # These values are temporarily taken from end-4's config
          drop_shadow = true;
          shadow_ignore_window = true;
          shadow_range = 20;
          shadow_offset = "0 2";
          shadow_render_power = 4;

          dim_inactive = false;
          dim_strength = 0.1;
          dim_special = 0;

          blur = {
            enabled = true;
            xray = true;
            special = false;
            new_optimizations = true;
            size = 14;
            passes = 4;
            brightness = 1;
            noise = 1.0e-2;
            contrast = 1;
            popups = true;
            popups_ignorealpha = 0.6;
          };
        };

        # These values are temporarily taken from end-4's config
        layerrule = [
          "noanim, anyrun"
          "blur, launcher"
          "ignorealpha 0.5, launcher"
        ];

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
          special_fallthrough = true; # TODO special workspaces (maybe change this)
        };

        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
          force_default_wallpaper = 0;
          # TODO vrr
          disable_autoreload = true;
          enable_swallow = true;
          swallow_regex = "^${hmConfig.home.sessionVariables.TERMINAL}$";
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          initial_workspace_tracking = 0;
        };

        # Only persists the cursor position when switching between workspaces
        cursor = {
          persistent_warps = true;
          warp_on_change_workspace = true;
        };

        monitor = [ "Unknown-1, disable" ];

        bindm = [
          "Super, mouse:272, movewindow"
          "Super, mouse:273, resizewindow"
        ];

        bindn = [ ", mouse:272, hy3:focustab, mouse" ]; # Non-capturing
        bindr = [ "Super, Super_L, exec, anyrun" ]; # On release

        bind = [
          "Super+Alt, H, hy3:makegroup, h"
          "Super+Alt, V, hy3:makegroup, v"
          "Super+Alt, Space, hy3:makegroup, opposite"
          "Super+Alt, T, hy3:makegroup, tab"

          # TODO Is hy3:changegroup needed?

          "Super, Up, hy3:movefocus, u"
          "Super, Right, hy3:movefocus, r"
          "Super, Down, hy3:movefocus, d"
          "Super, Left, hy3:movefocus, l"
          "Super+Ctrl, Plus, hy3:changefocus, raise"
          "Super+Ctrl, Minus, hy3:changefocus, lower"

          "Super+Shift, Up, hy3:movewindow, u"
          "Super+Shift, Right, hy3:movewindow, r"
          "Super+Shift, Down, hy3:movewindow, d"
          "Super+Shift, Left, hy3:movewindow, l"

          "Super, F, fullscreen, 0"
          "Super, G, fullscreen, 1"

          "Super, O, togglefloating"
          "Super, P, pin"

          "Super, 1, focusworkspaceoncurrentmonitor, 1"
          "Super, 2, focusworkspaceoncurrentmonitor, 2"
          "Super, 3, focusworkspaceoncurrentmonitor, 3"
          "Super, 4, focusworkspaceoncurrentmonitor, 4"
          "Super, 5, focusworkspaceoncurrentmonitor, 5"
          "Super, 6, focusworkspaceoncurrentmonitor, 6"
          "Super, 7, focusworkspaceoncurrentmonitor, 7"
          "Super, 8, focusworkspaceoncurrentmonitor, 8"
          "Super, 9, focusworkspaceoncurrentmonitor, 9"
          "Super, 0, focusworkspaceoncurrentmonitor, 10"
          "Super, Plus, focusworkspaceoncurrentmonitor, +1"
          "Super, Minus, focusworkspaceoncurrentmonitor, -1"

          "Super+Shift, 1, hy3:movetoworkspace, 1"
          "Super+Shift, 2, hy3:movetoworkspace, 2"
          "Super+Shift, 3, hy3:movetoworkspace, 3"
          "Super+Shift, 4, hy3:movetoworkspace, 4"
          "Super+Shift, 5, hy3:movetoworkspace, 5"
          "Super+Shift, 6, hy3:movetoworkspace, 6"
          "Super+Shift, 7, hy3:movetoworkspace, 7"
          "Super+Shift, 8, hy3:movetoworkspace, 8"
          "Super+Shift, 9, hy3:movetoworkspace, 9"
          "Super+Shift, 0, hy3:movetoworkspace, 0"
          "Super+Shift, Plus, hy3:movetoworkspace, +1"
          "Super+Shift, Minus, hy3:movetoworkspace, -1"

          "Super, Space, focusmonitor, +1"

          "Super, Q, hy3:killactive"

          "Super, T, exec, kitty"
        ];
      } cfg.settings;
    };
  };
}
