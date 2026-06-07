{
  lib,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    imports = [(lib.mkAliasOptionModule ["desktop" "hyprland" "settings"] ["hm" "wayland" "windowManager" "hyprland" "settings"])];

    options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";
    options.desktop.hyprland.bind = lib.mkOption {
      type = with lib.types; listOf (listOf (either str (attrsOf bool)));
      default = [];
      description = "Hyprland keybindings.";
    };

    config = lib.mkIf config.desktop.hyprland.enable {
      nix.settings.substituters = ["https://hyprland.cachix.org"];
      nix.settings.trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

      nixpkgs.overlays = [(_: _: {inherit (inputs.hyprland.packages.${pkgs.stdenv.system}) hyprland xdg-desktop-portal-hyprland;})];

      programs.hyprland.enable = true;
      programs.hyprland.withUWSM = true;

      theme.stylix.hmTargets.hyprland.hyprpaper.enable = false;

      console.enable = false;

      environment.variables.NIXOS_OZONE_WL = "1";

      hm = {
        home.packages = with pkgs; [hyprpicker wl-clipboard];

        systemd.user.services.hyprnotify = {
          Unit.Description = "hyprnotify";
          Unit.After = ["graphical-session.target"];
          Service.ExecStart = lib.getExe pkgs.hyprnotify;
          Service.Restart = "on-failure";
          Install.WantedBy = ["graphical-session.target"];
        };

        wayland.windowManager.hyprland = let
          plugins =
            [inputs.hy3.packages.${pkgs.stdenv.system}.default]
            ++ lib.optional (config.theme.windowOpacity != 1) inputs.hypr-darkwindow.packages.${pkgs.stdenv.system}.default;
        in {
          enable = true;
          systemd.enable = false;
          inherit plugins;

          settings = {
            config = {
              general = {
                gaps_in = 2;
                gaps_out = 5;
                layout = "hy3";
              };

              decoration.rounding = 12;
              decoration.blur.size = 3;

              input.repeat_rate = 35;
              input.repeat_delay = 200;

              misc = {
                disable_hyprland_logo = true;
                disable_splash_rendering = true;
                vrr = 2;
                animate_manual_resizes = true;
                disable_autoreload = true;
                enable_anr_dialog = false;
              };

              cursor = {
                hotspot_padding = 5;
                inactive_timeout = 5;
                hide_on_key_press = true;
              };

              ecosystem = {
                no_update_news = true;
                no_donation_nag = true;
                enforce_permissions = true;
              };
            };

            animation = {
              leaf = "global";
              enabled = true;
              speed = 3;
              bezier = "default";
            };

            permission = [
              {
                binary = "${lib.escapeRegex (lib.getExe pkgs.hyprpicker)}|${lib.escapeRegex (lib.getExe pkgs.grim)}";
                type = "screencopy";
                mode = "allow";
              }
              {
                binary = lib.join "|" (map (x: lib.escapeRegex "${x}/lib/lib${x.pname}.so") plugins);
                type = "plugin";
                mode = "allow";
              }
            ];

            bind = map (x: {_args = [(lib.head x) (lib.mkLuaInline (lib.elemAt x 1))] ++ (lib.drop 2 x);}) ([
                ["SUPER + mouse:272" "hl.dsp.window.drag()" {mouse = true;}]

                ["SUPER + I" "hl.dsp.window.resize({ x = 10, y = 0, relative = true })" {repeating = true;}]
                ["SUPER + ALT + I" "hl.dsp.window.resize({ x = 0, y = 10, relative = true })" {repeating = true;}]
                ["SUPER + D" "hl.dsp.window.resize({ x = -10, y = 0, relative = true })" {repeating = true;}]
                ["SUPER + ALT + D" "hl.dsp.window.resize({ x = 0, y = -10, relative = true })" {repeating = true;}]
                ["SUPER + F" "hl.dsp.window.fullscreen()"]
                ["SUPER + G" "hl.dsp.window.fullscreen({ mode = 'maximized' })"]
                ["SUPER + mouse:273" "hl.dsp.window.resize()" {mouse = true;}]

                ["SUPER + O" "hl.dsp.window.float()"]

                ["SUPER + 1" "hl.dsp.focus({ workspace = 1, on_current_monitor = true })"]
                ["SUPER + 2" "hl.dsp.focus({ workspace = 2, on_current_monitor = true })"]
                ["SUPER + 3" "hl.dsp.focus({ workspace = 3, on_current_monitor = true })"]
                ["SUPER + 4" "hl.dsp.focus({ workspace = 4, on_current_monitor = true })"]
                ["SUPER + 5" "hl.dsp.focus({ workspace = 5, on_current_monitor = true })"]
                ["SUPER + 6" "hl.dsp.focus({ workspace = 6, on_current_monitor = true })"]
                ["SUPER + 7" "hl.dsp.focus({ workspace = 7, on_current_monitor = true })"]
                ["SUPER + 8" "hl.dsp.focus({ workspace = 8, on_current_monitor = true })"]
                ["SUPER + 9" "hl.dsp.focus({ workspace = 9, on_current_monitor = true })"]

                ["SUPER + Space" "hl.dsp.focus({ monitor = '+1' })"]

                ["SUPER + S" "hl.dsp.exec_cmd('${lib.getExe pkgs.grim} -g \"$(${lib.getExe pkgs.slurp})\"')"]
                ["SUPER + P" "hl.dsp.exec_raw('${lib.getExe pkgs.hyprpicker} --autocopy --render-inactive')"]
                ["SUPER + C" "hl.dsp.global('shell:toggleCalculator')"]

                ["SUPER + CTRL + T" "hl.dsp.exec_raw('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')"]
                ["XF86AudioMute" "hl.dsp.exec_raw('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle')"]
                ["SUPER + CTRL + I" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+')" {repeating = true;}]
                ["XF86AudioRaiseVolume" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+')" {repeating = true;}]
                ["SUPER + CTRL + D" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-')" {repeating = true;}]
                ["XF86AudioLowerVolume" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-')" {repeating = true;}]
                ["SUPER + CTRL + SHIFT + I" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+')" {repeating = true;}]
                ["SHIFT + XF86AudioRaiseVolume" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+')" {repeating = true;}]
                ["SUPER + CTRL + SHIFT + D" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-')" {repeating = true;}]
                ["SHIFT + XF86AudioLowerVolume" "hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-')" {repeating = true;}]

                ["SUPER + ALT + S" "hl.dsp.exec_raw('systemctl suspend')"]
                ["SUPER + ALT + P" ''hl.dsp.exec_raw("${lib.getExe pkgs.hyprshutdown} --post-cmd 'systemctl poweroff'")'']
                ["SUPER + ALT + R" ''hl.dsp.exec_raw("${lib.getExe pkgs.hyprshutdown} --post-cmd 'systemctl reboot'")'']
              ]
              ++ config.desktop.hyprland.bind);
          };

          extraConfig = let
            hy3Binds = [
              ["SUPER + H" "hl.plugin.hy3.move_focus('left')"]
              ["SUPER + J" "hl.plugin.hy3.move_focus('down')"]
              ["SUPER + K" "hl.plugin.hy3.move_focus('up')"]
              ["SUPER + L" "hl.plugin.hy3.move_focus('right')"]

              ["SUPER + SHIFT + H" "hl.plugin.hy3.move_window('left')"]
              ["SUPER + SHIFT + J" "hl.plugin.hy3.move_window('down')"]
              ["SUPER + SHIFT + K" "hl.plugin.hy3.move_window('up')"]
              ["SUPER + SHIFT + L" "hl.plugin.hy3.move_window('right')"]

              ["SUPER + Q" "hl.plugin.hy3.kill_active()"]

              ["SUPER + ALT + H" "hl.plugin.hy3.make_group('h', { ephemeral = true })"]
              ["SUPER + ALT + V" "hl.plugin.hy3.make_group('v', { ephemeral = true })"]

              ["SUPER + SHIFT + 1" "hl.plugin.hy3.move_to_workspace(1)"]
              ["SUPER + SHIFT + 2" "hl.plugin.hy3.move_to_workspace(2)"]
              ["SUPER + SHIFT + 3" "hl.plugin.hy3.move_to_workspace(3)"]
              ["SUPER + SHIFT + 4" "hl.plugin.hy3.move_to_workspace(4)"]
              ["SUPER + SHIFT + 5" "hl.plugin.hy3.move_to_workspace(5)"]
              ["SUPER + SHIFT + 6" "hl.plugin.hy3.move_to_workspace(6)"]
              ["SUPER + SHIFT + 7" "hl.plugin.hy3.move_to_workspace(7)"]
              ["SUPER + SHIFT + 8" "hl.plugin.hy3.move_to_workspace(8)"]
              ["SUPER + SHIFT + 9" "hl.plugin.hy3.move_to_workspace(9)"]
            ];
          in ''
            if hl.plugin.hy3 ~= nil then
              ${lib.join "\n  " (map (x: "hl.bind('${lib.head x}', ${lib.elemAt x 1})") hy3Binds)}
            end

            if hl.plugin.darkwindow ~= nil then
              hl.config({
                plugin = {
                  darkwindow = {
                    load_shaders = "chromakey",
                  }
                }
              })

              hl.plugin.darkwindow.load_shader("opacity", {
                from = "chromakey",
                args = "bkg=[${toString (with config.theme.colors; [base00-dec-r base00-dec-g base00-dec-b])}] similarity=1 targetOpacity=${toString config.theme.windowOpacity}",
              })

              hl.window_rule({
                match = { fullscreen = false },
                ["darkwindow:shade"] = "opacity",
              })
              hl.window_rule({
                match = { fullscreen_state_internal = 1 },
                ["darkwindow:shade"] = "opacity",
              })
            end
          '';
        };
      };
    };
  };
}
