{
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

    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        general = {
	  gaps_in = 4;
	  gaps_out = 5;
	  # TODO layout
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

	animations = {}; # TODO

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
	  # TODO window swallowing
	  focus_on_active = true;
	  new_window_takes_over_fullscreen = 2;
	  # TODO initial_workspace_tracking
	};

	binds = {
	  scroll_event_delay = 0;
	  # TODO workspace settings and after
	};

        bind = [ "Super, T, exec, kitty" ];
      } // cfg.settings;
    };
  };
}
