{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.hyprsunset.enable = lib.mkEnableOption "Hyprsunset";

    config = lib.mkIf config.desktop.hyprsunset.enable {
      dependencies = ["desktop.hyprland"];

      hm.services.hyprsunset.enable = true;
      hm.services.hyprsunset.settings.profile = [
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

      services.udev.extraRules = ''ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${lib.getExe' pkgs.coreutils "chmod"} a+w /sys/class/backlight/%k/brightness"'';

      desktop.hyprland.bind = let
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
      in [
        ["SUPER + SHIFT + I" "hl.dsp.exec_raw('${increase}')" {repeating = true;}]
        ["SUPER + SHIFT + D" "hl.dsp.exec_raw('${decrease}')" {repeating = true;}]
        ["XF86MonBrightnessUp" "hl.dsp.exec_raw('${increase}')" {repeating = true;}]
        ["XF86MonBrightnessDown" "hl.dsp.exec_raw('${decrease}')" {repeating = true;}]
      ];
    };
  };
}
