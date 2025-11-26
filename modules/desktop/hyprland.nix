{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  hyprlandVersion = "0.52.0";
  inherit (config.theme) colors;
in {
  inputs = {
    hyprland.url = "github:hyprwm/Hyprland/v${hyprlandVersion}";
    hy3.url = "github:outfoxxed/hy3/hl${hyprlandVersion}";
    hy3.inputs.hyprland.follows = "hyprland";
    hypr-darkwindow.url = "github:micha4w/Hypr-DarkWindow/v${hyprlandVersion}";
    hypr-darkwindow.inputs.hyprland.follows = "hyprland";
    hyprland-easymotion = {
      url = "github:zakk4223/hyprland-easymotion";
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

      systemd.services.autologin = {
        description = "Autologin";
        restartIfChanged = false;
        after = ["systemd-user-sessions.service" "plymouth-quit-wait.service"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${lib.getExe pkgs.autologin} noah ${lib.getExe inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland}";
          IgnoreSIGPIPE = "no";
          SendSIGHUP = "yes";
          TimeoutStopSec = "30s";
          KeyringMode = "shared";
          Restart = "always";
          RestartSec = "10";
        };
        startLimitBurst = 5;
        startLimitIntervalSec = 30;
        aliases = ["display-manager.service"];
        wantedBy = ["multi-user.target"];
      };
      security.pam.services.autologin = {
        name = "autologin";
        startSession = true;
        setLoginUid = true;
        updateWtmp = true;
      };
    };

    hm = {
      home.packages = with pkgs; [hyprpicker wl-clipboard];
      home.sessionVariables.NIXOS_OZONE_WL = "1";

      wayland.windowManager.hyprland = {
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
            "plugin:shadewindow chromakey bkg=[${toString [colors.base00-dec-r colors.base00-dec-g colors.base00-dec-b]}] similarity=1 targetOpacity=${toString config.theme.windowOpacity}, fullscreen:0";

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

            "Super, I, resizeactive, 10% 0"
            "Super_Alt, I, resizeactive, 0 10%"
            "Super, D, resizeactive, -10% 0"
            "Super_Alt, D, resizeactive, 0 -10%"

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
          ];
        };
      };

      services.hyprsunset.enable = true;
      services.hyprsunset.settings.profile = [
        {time = "7:30";}
        {
          time = "17:00";
          temperature = 5500;
          gamma = 0.9;
        }
        {
          time = "18:00";
          temperature = 5000;
          gamma = 0.8;
        }
        {
          time = "19:00";
          temperature = 4500;
          gamma = 0.7;
        }
        {
          time = "20:00";
          temperature = 4000;
          gamma = 0.6;
        }
      ];
    };
  };
}
