{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.desktop.hyprland;
in {
  imports = [(mkAliasOptionModule ["desktop" "hyprland" "settings"] ["hm" "wayland" "windowManager" "hyprland" "settings"])];

  options.desktop.hyprland.enable = mkEnableOption "Hyprland";

  config = mkIf cfg.enable {
    os = {
      # TODO Remove once https://github.com/hyprwm/Hyprland/pull/5777 gets merged
      nixpkgs.overlays = [
        (final: prev: {
          hyprland = prev.hyprland.overrideAttrs (old: {
            patches =
              old.patches
              or []
              ++ [
                (pkgs.fetchpatch {
                  url = "https://patch-diff.githubusercontent.com/raw/hyprwm/Hyprland/pull/5777.diff";
                  hash = "sha256-yWMp8VUeo171wqRS0mkI8ww4iTDc/6xzg4pgmM+vdXk=";
                })
              ];
          });
        })
      ];

      programs.hyprland.enable = true;
    };

    hm.home.sessionVariables.NIXOS_OZONE_WL = 1;

    hm.wayland.windowManager.hyprland = {
      enable = true;

      plugins = [pkgs.hyprlandPlugins.hy3];

      settings = let
        getColor = x: "rgb(${removePrefix "#" config.theme.colors.${x}})";
      in {
        general = {
          gaps_in = 2;
          gaps_out = 5;
          "col.inactive_border" = getColor "inactiveWindowBorder";
          "col.active_border" = getColor "activeWindowBorder";
          layout = "hy3";
          # TODO allow_tearing
        };

        decoration = {
          rounding = 12;
          "col.shadow" = getColor "background"; # TODO Maybe adjust the opacity?

          # TODO Dim inactive windows
          # TODO Style floating windows and popups (blur, dimming)
          # TODO Style transparent windows (blur, shadows, dimming)

          blur.size = 2;
        };

        # Heavily inspired by end-4's config
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
            "fade, 1, 3, md3_decel"
            "workspaces, 1, 7, menu_decel, slide"
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
          focus_on_activate = true;
          new_window_takes_over_fullscreen = 2;
          initial_workspace_tracking = 1; # TODO Doesn't work with window swallowing (e.g. Slack)
        };

        binds.workspace_center_on = 1;

        cursor = {
          persistent_warps = true; # TODO Doesn't work (with hy3:changefocus?)
          warp_on_change_workspace = true; # TODO Is this actually the same as binds.workspace_center_on?
        };

        plugin.hy3.tabs = {
          padding = 2;
          rounding = 6;
          render_text = false;
          "col.inactive" = getColor "inactiveTabBackground";
          "col.active" = getColor "activeTabBackground";
          # TODO Setup urgent tab color?
        };

        bindm = [
          "Super, mouse:272, movewindow"
          "Super, mouse:273, resizewindow"
        ];

        bind = [
          "Super+Alt, R, hy3:makegroup, h, ephemeral"
          "Super+Alt, S, hy3:makegroup, v, ephemeral"
          "Super+Alt, T, hy3:makegroup, tab, ephemeral"

          # TODO Is hy3:changegroup needed?

          "Super, H, hy3:movefocus, l"
          "Super, J, hy3:movefocus, d"
          "Super, K, hy3:movefocus, u"
          "Super, L, hy3:movefocus, r"
          "Super, Plus, hy3:changefocus, raise"
          "Super, Minus, hy3:changefocus, lower"

          "Super+Shift, H, hy3:movewindow, l"
          "Super+Shift, J, hy3:movewindow, d"
          "Super+Shift, K, hy3:movewindow, u"
          "Super+Shift, L, hy3:movewindow, r"

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

          "Super, Space, focusmonitor, +1"

          "Super, Q, hy3:killactive"
        ];
      };
    };
  };
}
