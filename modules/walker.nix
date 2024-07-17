{
  lib,
  inputs,
  config,
  ...
}:
with lib;
let
  cfg = config.walker;
in
{
  inputs.walker.url = "github:abenz1267/walker";

  hmImports = [ inputs.walker.homeManagerModules.default ];

  options.walker.enable = mkEnableOption "walker";

  config = mkIf cfg.enable {
    os.nix.settings = {
      substituters = [ "https://walker.cachix.org" ];
      trusted-public-keys = [ "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" ];
    };

    hm.programs.walker = {
      enable = true;
      runAsService = true;

      config = {
        placeholder = "Search...";
        ignore_mouse = false;
        ssh_host_file = "";
        disable_up_history = false;
        enable_typeahead = false;
        show_initial_entries = true;
        fullscreen = false;
        scrollbar_policy = "automatic";
        websearch.engines = [ "google" ];
        hyprland.context_aware_history = false;
        applications = {
          enable_cache = false;
          ignore_actions = false;
        };
        activation_mode = {
          disabled = false;
          use_f_keys = false;
          use_alt = false;
        };
        search = {
          delay = 0;
          hide_icons = false;
          margin_spinner = 10;
          hide_spinner = false;
        };
        runner.excludes = [ "rm" ];
        clipboard = {
          max_entries = 10;
          image_height = 300;
        };
        align = {
          ignore_exlusive = true;
          width = 400;
          horizontal = "center";
          vertical = "start";
          anchors = {
            top = false;
            left = false;
            bottom = false;
            right = false;
          };
          margins = {
            top = 20;
            bottom = 0;
            end = 0;
            start = 0;
          };
        };
        list = {
          height = 300;
          margin_top = 10;
          always_show = true;
          hide_sub = false;
          max_entries = 50;
        };
        orientation = "vertical";
        icons = {
          theme = "";
          hide = false;
          size = 28;
          image_height = 200;
        };
        modules = [
          { name = "applications"; }
          {
            name = "websearch";
            prefix = "?";
          }
          {
            name = "finder";
            prefix = "/";
          }
          {
            name = "emojis";
            prefix = ":";
          }
        ];
      };
    };
  };
}
