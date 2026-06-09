{
  wlib,
  lib,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.hyprland.enable = lib.mkEnableOption "Hyprland";

    config = lib.mkIf config.desktop.hyprland.enable {
      nix.settings.substituters = ["https://hyprland.cachix.org"];
      nix.settings.trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];

      nixpkgs.overlays = [(_: _: {inherit (inputs.hyprland.packages.${pkgs.stdenv.system}) xdg-desktop-portal-hyprland;})];

      programs.hyprland.enable = true;
      programs.hyprland.withUWSM = true;

      theme.stylix.hmTargets.hyprland.hyprpaper.enable = false;

      console.enable = false;

      environment.variables.NIXOS_OZONE_WL = "1";

      hm = {
        home.packages = [pkgs.wl-clipboard];

        systemd.user.services.hyprnotify = {
          Unit.Description = "hyprnotify";
          Unit.After = ["graphical-session.target"];
          Service.ExecStart = lib.getExe pkgs.hyprnotify;
          Service.Restart = "on-failure";
          Install.WantedBy = ["graphical-session.target"];
        };

        services.hyprsunset.enable = true;
        services.hyprsunset.settings.profile = [
          {
            time = "18:00";
            temperature = 5500;
          }
          {
            time = "19:00";
            temperature = 5000;
          }
          {
            time = "20:00";
            temperature = 4500;
          }
          {
            time = "21:00";
            temperature = 4000;
          }
          {
            time = "7:00";
            temperature = 5000;
          }
          {
            time = "8:00";
            temperature = 6000;
          }
        ];
      };

      services.udev.extraRules = ''ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${lib.getExe' pkgs.coreutils "chmod"} a+w /sys/class/backlight/%k/brightness"'';
    };
  };

  flake.wrappers.compositor = {
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];

    package = inputs.hyprland.packages.${pkgs.stdenv.system}.hyprland;

    flags."--config" = config.constructFiles.config.path;

    constructFiles.config.relPath = "${config.binName}-config.lua";
    constructFiles.config.content = let
      plugins = [inputs.hy3.packages.${pkgs.stdenv.system}.default inputs.hypr-darkwindow.packages.${pkgs.stdenv.system}.default];
      increase = pkgs.writers.writeNu "brightness-increase" ''
        if ('/sys/class/backlight/intel_backlight/brightness' | path type) != 'file' {
          hyprctl hyprsunset gamma +10
          return
        }
        let current = open /sys/class/backlight/intel_backlight/brightness | into int
        let step = (open /sys/class/backlight/intel_backlight/max_brightness | into int) / 10
        if $current == $step * 10 { return }
        (($current + 1) / $step + 1 | math floor) * $step | math floor | save -f /sys/class/backlight/intel_backlight/brightness
      '';
      decrease = pkgs.writers.writeNu "brightness-decrease" ''
        if ('/sys/class/backlight/intel_backlight/brightness' | path type) != 'file' {
          hyprctl hyprsunset gamma -10
          return
        }
        let current = open /sys/class/backlight/intel_backlight/brightness | into int
        let step = (open /sys/class/backlight/intel_backlight/max_brightness | into int) / 10
        if $current == 0 { return }
        ($current / $step - 1 | math ceil) * $step | math floor | save -f /sys/class/backlight/intel_backlight/brightness
      '';
    in ''
      -- Config
      hl.config({
        general = {
          gaps_in = 2,
          gaps_out = 5,
          col = {
            inactive_border = '#859289',
            active_border = '#a7c080',
          },
          layout = 'hy3',
        },
        decoration = {
          rounding = 8,
          blur = {
            size = 2,
            brightness = 0.75,
            popups = true,
          },
          shadow = { color = '#2d353b' },
          glow = {
            enabled = true,
            range = 3,
            color = '#a7c080',
          },
        },
        input = {
          repeat_rate = 35,
          repeat_delay = 200,
        },
        misc = {
          disable_hyprland_logo = true,
          disable_splash_rendering = true,
          vrr = 2,
          disable_autoreload = true,
          enable_anr_dialog = false,
        },
        cursor = {
          hotspot_padding = 5,
          inactive_timeout = 5,
          hide_on_key_press = true,
        },
        ecosystem = {
          no_update_news = true,
          no_donation_nag = true,
          enforce_permissions = true,
        },
      })

      hl.animation({
        leaf = 'global',
        enabled = true,
        speed = 3,
        bezier = 'default',
      })

      hl.device({
        name = 'charachorder-charachorder-two-s3-keyboard',
        kb_layout = 'cc',
      })

      -- Binds
      hl.bind('SUPER + T', hl.dsp.exec_raw('ghostty +new-window')) -- Ghostty natively sets up systemd services
      hl.bind('SUPER + B', hl.dsp.exec_raw('uwsm-app qutebrowser'))

      hl.bind('SUPER + mouse:272', hl.dsp.window.drag(), { mouse = true })

      hl.bind('SUPER + mouse:273', hl.dsp.window.resize(), { mouse = true })
      hl.bind('SUPER + I', hl.dsp.window.resize({ x = 10, y = 0, relative = true }), { repeating = true })
      hl.bind('SUPER + D', hl.dsp.window.resize({ x = -10, y = 0, relative = true }), { repeating = true })
      hl.bind('SUPER + ALT + I', hl.dsp.window.resize({ x = 0, y = 10, relative = true }), { repeating = true })
      hl.bind('SUPER + ALT + D', hl.dsp.window.resize({ x = 0, y = -10, relative = true }), { repeating = true })
      hl.bind('SUPER + G', hl.dsp.window.fullscreen({ mode = 'maximized' }))
      hl.bind('SUPER + F', hl.dsp.window.fullscreen())

      hl.bind('SUPER + O', hl.dsp.window.float())

      hl.bind('SUPER + Space', hl.dsp.focus({ monitor = '+1' }))
      hl.bind('SUPER + 1', hl.dsp.focus({ workspace = 1, on_current_monitor = true }))
      hl.bind('SUPER + 2', hl.dsp.focus({ workspace = 2, on_current_monitor = true }))
      hl.bind('SUPER + 3', hl.dsp.focus({ workspace = 3, on_current_monitor = true }))
      hl.bind('SUPER + 4', hl.dsp.focus({ workspace = 4, on_current_monitor = true }))
      hl.bind('SUPER + 5', hl.dsp.focus({ workspace = 5, on_current_monitor = true }))
      hl.bind('SUPER + 6', hl.dsp.focus({ workspace = 6, on_current_monitor = true }))
      hl.bind('SUPER + 7', hl.dsp.focus({ workspace = 7, on_current_monitor = true }))
      hl.bind('SUPER + 8', hl.dsp.focus({ workspace = 8, on_current_monitor = true }))
      hl.bind('SUPER + 9', hl.dsp.focus({ workspace = 9, on_current_monitor = true }))

      hl.bind('SUPER + S', hl.dsp.exec_cmd('${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})"'))
      hl.bind('SUPER + P', hl.dsp.exec_raw('${lib.getExe pkgs.hyprpicker} --autocopy --render-inactive'))
      hl.bind('SUPER + C', hl.dsp.global('shell:toggleCalculator'))

      hl.bind('SUPER + CTRL + T', hl.dsp.exec_raw('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'))
      hl.bind('XF86AudioMute', hl.dsp.exec_raw('wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'))
      hl.bind('SUPER + CTRL + I', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+'), { repeating = true })
      hl.bind('XF86AudioRaiseVolume', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%+'), { repeating = true })
      hl.bind('SUPER + CTRL + SHIFT + I', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+'), { repeating = true })
      hl.bind('SHIFT + XF86AudioRaiseVolume', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%+'), { repeating = true })
      hl.bind('SUPER + CTRL + D', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-'), { repeating = true })
      hl.bind('XF86AudioLowerVolume', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 10%-'), { repeating = true })
      hl.bind('SUPER + CTRL + SHIFT + D', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-'), { repeating = true })
      hl.bind('SHIFT + XF86AudioLowerVolume', hl.dsp.exec_raw('wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-'), { repeating = true })

      hl.bind('SUPER + SHIFT + I', hl.dsp.exec_raw('${increase}'), { repeating = true })
      hl.bind('XF86MonBrightnessUp', hl.dsp.exec_raw('${increase}'), { repeating = true })
      hl.bind('SUPER + SHIFT + D', hl.dsp.exec_raw('${decrease}'), { repeating = true })
      hl.bind('XF86MonBrightnessDown', hl.dsp.exec_raw('${decrease}'), { repeating = true })

      hl.bind('SUPER + ALT + S', hl.dsp.exec_raw('systemctl suspend'))
      hl.bind('SUPER + ALT + P', hl.dsp.exec_raw("${lib.getExe pkgs.hyprshutdown} --post-cmd 'systemctl poweroff'"))
      hl.bind('SUPER + ALT + R', hl.dsp.exec_raw("${lib.getExe pkgs.hyprshutdown} --post-cmd 'systemctl reboot'"))

      -- Window / layer rules
      hl.window_rule({
        match = { class = 'com.qutebrowser-editor' },
        float = true,
      })
      hl.window_rule({
        match = { class = 'com.termfilechooser' },
        float = true,
      })

      hl.layer_rule({
        match = { namespace = 'shell-(bar|calculator)' },
        blur = true,
        ignore_alpha = 0,
      })

      -- Permissions
      hl.permission({
        binary = '${lib.replaceString "\\" "\\\\" "${lib.escapeRegex (lib.getExe pkgs.hyprpicker)}|${lib.escapeRegex (lib.getExe pkgs.grim)}"}',
        type = 'screencopy',
        mode = 'allow',
      })
      hl.permission({
        binary = '${lib.replaceString "\\" "\\\\" (lib.join "|" (map (x: lib.escapeRegex "${x}/lib/lib${x.pname}.so") plugins))}',
        type = 'plugin',
        mode = 'allow',
      })

      -- Plugins
      hl.on('hyprland.start', function()
        ${lib.join "\n  " (map (x: "hl.exec_cmd('${lib.getExe' config.package "hyprctl"} plugin load ${x}/lib/lib${x.pname}.so')") plugins)}
      end)

      if hl.plugin.hy3 ~= nil then
        hl.bind('SUPER + H', hl.plugin.hy3.move_focus('left'))
        hl.bind('SUPER + J', hl.plugin.hy3.move_focus('down'))
        hl.bind('SUPER + K', hl.plugin.hy3.move_focus('up'))
        hl.bind('SUPER + L', hl.plugin.hy3.move_focus('right'))
        hl.bind('SUPER + SHIFT + H', hl.plugin.hy3.move_window('left'))
        hl.bind('SUPER + SHIFT + J', hl.plugin.hy3.move_window('down'))
        hl.bind('SUPER + SHIFT + K', hl.plugin.hy3.move_window('up'))
        hl.bind('SUPER + SHIFT + L', hl.plugin.hy3.move_window('right'))
        hl.bind('SUPER + Q', hl.plugin.hy3.kill_active())
        hl.bind('SUPER + ALT + H', hl.plugin.hy3.make_group('h', { ephemeral = true }))
        hl.bind('SUPER + ALT + V', hl.plugin.hy3.make_group('v', { ephemeral = true }))
        hl.bind('SUPER + SHIFT + 1', hl.plugin.hy3.move_to_workspace(1))
        hl.bind('SUPER + SHIFT + 2', hl.plugin.hy3.move_to_workspace(2))
        hl.bind('SUPER + SHIFT + 3', hl.plugin.hy3.move_to_workspace(3))
        hl.bind('SUPER + SHIFT + 4', hl.plugin.hy3.move_to_workspace(4))
        hl.bind('SUPER + SHIFT + 5', hl.plugin.hy3.move_to_workspace(5))
        hl.bind('SUPER + SHIFT + 6', hl.plugin.hy3.move_to_workspace(6))
        hl.bind('SUPER + SHIFT + 7', hl.plugin.hy3.move_to_workspace(7))
        hl.bind('SUPER + SHIFT + 8', hl.plugin.hy3.move_to_workspace(8))
        hl.bind('SUPER + SHIFT + 9', hl.plugin.hy3.move_to_workspace(9))
      end

      if hl.plugin.darkwindow ~= nil then
        hl.config({ plugin = { darkwindow = { load_shaders = 'chromakey' } } })

        hl.plugin.darkwindow.load_shader('opacity', {
          from = 'chromakey',
          args = 'bkg=[0.175781 0.207031 0.230469] similarity=1 targetOpacity=0.750000',
        })

        hl.window_rule({
          match = { fullscreen = false },
          ['darkwindow:shade'] = 'opacity',
        })
        hl.window_rule({
          match = { fullscreen_state_internal = 1 },
          ['darkwindow:shade'] = 'opacity',
        })
      end
    '';
  };
}
