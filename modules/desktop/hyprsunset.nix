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

      services.udev.extraRules = ''ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="intel_backlight", MODE="0666", RUN+="${lib.getExe' pkgs.coreutils "chmod"} a+w /sys/class/backlight/%k/brightness"'';

      desktop.hyprland.settings.binde = let
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
        "Super_Shift, I, exec, ${increase}"
        "Super_Shift, D, exec, ${decrease}"
        ", XF86MonBrightnessUp, exec, ${increase}"
        ", XF86MonBrightnessDown, exec, ${decrease}"
      ];
    };
  };
}
