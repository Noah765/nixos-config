{
  lib,
  inputs,
  pkgs,
  hmOptions,
  config,
  ...
}:
with lib;
let
  cfg = config.hyprland;
in
{
  inputs = {
    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    bird-nix-lib = {
      url = "github:spikespaz/bird-nix-lib";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
      };
    };
    hyprnix = {
      url = "github:hyprland-community/hyprnix";
      inputs = {
        nixpkgs.follows = "hyprland/nixpkgs";
        systems.follows = "hyprland/systems";
        hyprland.follows = "hyprland";
        hyprland-protocols.follows = "hyprland/xdph/hyprland-protocols";
        hyprland-xdph.follows = "hyprland/xdph";
        hyprlang.follows = "hyprland/hyprlang";
        bird-nix-lib.follows = "bird-nix-lib";
      };
    };
    hy3 = {
      url = "github:outfoxxed/hy3";
      inputs.hyprland.follows = "hyprland";
    };
  };

  hmImports = [ inputs.hyprnix.homeManagerModules.default ];

  options.hyprland =
    let
      options = hmOptions.wayland.windowManager.hyprland;
    in
    {
      enable = mkEnableOption "hyprland";
      config = options.config;
      monitors = options.monitors // {
        default.default = {
          name = "";
          resolution = "highres";
        };
      };
    };

  config = mkIf cfg.enable {
    os = {
      nix.settings = {
        substituters = [ "https://hyprland.cachix.org" ];
        trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
      };

      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.system}.hyprland;
      };
    };

    hm.home.sessionVariables.NIXOS_OZONE_WL = 1;

    hm.wayland.windowManager.hyprland = {
      enable = true;

      plugins = [ inputs.hy3.packages.${pkgs.system}.default ];

      config = attrsets.recursiveUpdate {
        general = {
          gaps_in = 2;
          gaps_out = 5;
          layout = "hy3";
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
          special_fallthrough = true; # TODO special workspaces (maybe change this)
        };

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
          initial_workspace_tracking = 0;
        };

        # Only persists the cursor position when switching between workspaces
        cursor = {
          persistent_warps = true;
          warp_on_change_workspace = true;
        };

        monitor = [ "Unknown-1, disable" ];
      } cfg.config;

      monitors = cfg.monitors;

      animations.bezierCurve = { }; # Hyprnix shouldn't include it's default bezier curves

      keyBinds = {
        bind."Super+Alt, H" = "hy3:makegroup, h";
        bind."Super+Alt, V" = "hy3:makegroup, v";
        bind."Super+Alt, Space" = "hy3:makegroup, opposite";
        bind."Super+Alt, T" = "hy3:makegroup, tab";

        # TODO Is hy3:changegroup needed?

        bind."Super, Up" = "hy3:movefocus, u";
        bind."Super, Right" = "hy3:movefocus, r";
        bind."Super, Down" = "hy3:movefocus, d";
        bind."Super, Left" = "hy3:movefocus, l";
        bind."Super+Ctrl, Plus" = "hy3:changefocus, raise";
        bind."Super+Ctrl, Minus" = "hy3:changefocus, lower";
        bindn.", mouse:272" = "hy3:focustab, mouse";

        bind."Super+Shift, Up" = "hy3:movewindow, u";
        bind."Super+Shift, Right" = "hy3:movewindow, r";
        bind."Super+Shift, Down" = "hy3:movewindow, d";
        bind."Super+Shift, Left" = "hy3:movewindow, l";
        bindm."Super, mouse:272" = "movewindow";

        bindm."Super, mouse:273" = "resizewindow";
        bind."Super, F" = "fullscreen, 0";
        bind."Super, G" = "fullscreen, 1";

        bind."Super, O" = "togglefloating";
        bind."Super, P" = "pin";

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
        bind."Super, Plus" = "focusworkspaceoncurrentmonitor, +1";
        bind."Super, Minus" = "focusworkspaceoncurrentmonitor, -1";

        bind."Super+Shift, 1" = "hy3:movetoworkspace, 1";
        bind."Super+Shift, 2" = "hy3:movetoworkspace, 2";
        bind."Super+Shift, 3" = "hy3:movetoworkspace, 3";
        bind."Super+Shift, 4" = "hy3:movetoworkspace, 4";
        bind."Super+Shift, 5" = "hy3:movetoworkspace, 5";
        bind."Super+Shift, 6" = "hy3:movetoworkspace, 6";
        bind."Super+Shift, 7" = "hy3:movetoworkspace, 7";
        bind."Super+Shift, 8" = "hy3:movetoworkspace, 8";
        bind."Super+Shift, 9" = "hy3:movetoworkspace, 9";
        bind."Super+Shift, 0" = "hy3:movetoworkspace, 0";
        bind."Super+Shift, Plus" = "hy3:movetoworkspace, +1";
        bind."Super+Shift, Minus" = "hy3:movetoworkspace, -1";

        bind."Super, Space" = "focusmonitor, +1";

        bind."Super, Q" = "hy3:killactive";

        bind."Super, T" = "exec, kitty";
      };
    };
  };
}
