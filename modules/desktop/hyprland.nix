{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (config.theme) colors;
  hyprlandVersion = "0.52";
  hyprlandPatch = "2";
in {
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland/v${hyprlandVersion}.${hyprlandPatch}";
    hy3.url = "github:outfoxxed/hy3/hl${hyprlandVersion}.0";
    hy3.inputs.hyprland.follows = "hyprland";
    hypr-darkwindow.url = "github:micha4w/Hypr-DarkWindow/v${hyprlandVersion}.${hyprlandPatch}";
    hypr-darkwindow.inputs.hyprland.follows = "hyprland";
    hyprland-easymotion = {
      url = "github:zakk4223/hyprland-easymotion/d46fa73d";
      inputs.nixpkgs.follows = "hyprland/nixpkgs";
      inputs.hyprland.follows = "hyprland";
    };
  };

  imports = [(lib.mkAliasOptionModule ["desktop" "hyprland" "settings"] ["hm" "wayland" "windowManager" "hyprland" "settings"])];

  options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

  config = lib.mkIf config.desktop.hyprland.enable {
    os = {
      programs.hyprland = {
        enable = true;
        package = inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland;
        portalPackage = inputs.hyprland.packages.${pkgs.stdenv.system}.xdg-desktop-portal-hyprland;
      };

      nix.settings.substituters = ["https://hyprland.cachix.org"];
      nix.settings.trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

      console.enable = false;
    };

    hm.home = {
      packages = with pkgs; [hyprpicker wl-clipboard];
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    hm.wayland.windowManager.hyprland = {
      enable = true;
      package = null;
      portalPackage = null;

      plugins =
        [inputs.hy3.packages.${pkgs.stdenv.system}.hy3 inputs.hyprland-easymotion.packages.${pkgs.stdenv.system}.hyprland-easymotion]
        ++ lib.optional (config.theme.windowOpacity != 1) inputs.hypr-darkwindow.packages.${pkgs.stdenv.system}.Hypr-DarkWindow;

      settings = {
        exec-once = lib.getExe pkgs.hyprnotify;

        general = {
          gaps_in = 2;
          gaps_out = 5;
          layout = "hy3";
        };

        decoration.rounding = 12;
        decoration.blur.size = 3;

        animations.animation = "global, 1, 3, default";

        input.repeat_rate = 35;
        input.repeat_delay = 200;

        misc = {
          disable_splash_rendering = true;
          vrr = 2;
          animate_manual_resizes = true;
          disable_autoreload = true;
          new_window_takes_over_fullscreen = 2;
          enable_anr_dialog = false;
        };

        cursor = {
          hotspot_padding = 5;
          inactive_timeout = 5;
          hide_on_key_press = true;
        };

        ecosystem.no_update_news = true;
        ecosystem.no_donation_nag = true;

        windowrule =
          lib.mkIf (config.theme.windowOpacity != 1)
          ["plugin:shadewindow chromakey bkg=[${toString [colors.base00-dec-r colors.base00-dec-g colors.base00-dec-b]}] similarity=1 targetOpacity=${toString config.theme.windowOpacity}, fullscreen:0"];

        plugin.easymotion = {
          textsize = 30;
          textcolor = "rgb(${colors.base05})";
          bgcolor = "rgb(${colors.base01})";
          textpadding = 10;
        };

        bindm = ["Super, mouse:272, movewindow" "Super, mouse:273, resizewindow"];

        bind = [
          "Super_Alt, H, hy3:makegroup, h, ephemeral"
          "Super_Alt, V, hy3:makegroup, v, ephemeral"

          "Super, H, hy3:movefocus, l"
          "Super, J, hy3:movefocus, d"
          "Super, K, hy3:movefocus, u"
          "Super, L, hy3:movefocus, r"
          "Super, W, easymotion, action:hyprctl dispatch focuswindow address:{}"

          "Super_Shift, H, hy3:movewindow, l"
          "Super_Shift, J, hy3:movewindow, d"
          "Super_Shift, K, hy3:movewindow, u"
          "Super_Shift, L, hy3:movewindow, r"

          "Super, F, fullscreen, 0"
          "Super, G, fullscreen, 1"

          "Super, O, togglefloating"
          "Super, P, pin"

          "Super, Q, hy3:killactive"

          "Super, 1, focusworkspaceoncurrentmonitor, 1"
          "Super, 2, focusworkspaceoncurrentmonitor, 2"
          "Super, 3, focusworkspaceoncurrentmonitor, 3"
          "Super, 4, focusworkspaceoncurrentmonitor, 4"
          "Super, 5, focusworkspaceoncurrentmonitor, 5"
          "Super, 6, focusworkspaceoncurrentmonitor, 6"
          "Super, 7, focusworkspaceoncurrentmonitor, 7"
          "Super, 8, focusworkspaceoncurrentmonitor, 8"
          "Super, 9, focusworkspaceoncurrentmonitor, 9"

          "Super_Shift, 1, hy3:movetoworkspace, 1"
          "Super_Shift, 2, hy3:movetoworkspace, 2"
          "Super_Shift, 3, hy3:movetoworkspace, 3"
          "Super_Shift, 4, hy3:movetoworkspace, 4"
          "Super_Shift, 5, hy3:movetoworkspace, 5"
          "Super_Shift, 6, hy3:movetoworkspace, 6"
          "Super_Shift, 7, hy3:movetoworkspace, 7"
          "Super_Shift, 8, hy3:movetoworkspace, 8"
          "Super_Shift, 9, hy3:movetoworkspace, 9"

          "Super, Space, focusmonitor, +1"

          "Super, C, exec, ${lib.getExe pkgs.hyprpicker} --autocopy --render-inactive"
          "Super, R, exec, ${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\""

          "Super_Alt, S, exec, systemctl suspend"
          "Super_Alt, P, exec, systemctl poweroff"
          "Super_Alt, R, exec, systemctl reboot"
        ];

        binde = [
          "Super, I, resizeactive, 10% 0"
          "Super_Alt, I, resizeactive, 0 10%"
          "Super, D, resizeactive, -10% 0"
          "Super_Alt, D, resizeactive, 0 -10%"

          "Super_Ctrl, T, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          "Super_Ctrl, I, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
          "Super_Ctrl, D, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
          ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
          ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+"
          ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-"
        ];
      };
    };
  };
}
