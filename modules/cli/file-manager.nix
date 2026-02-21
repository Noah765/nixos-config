{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    imports = [(lib.mkAliasOptionModule ["cli" "fileManager" "theme"] ["hm" "programs" "yazi" "flavors" "theme"])];

    options.cli.fileManager.enable = lib.mkEnableOption "Yazi";

    config = lib.mkIf config.cli.fileManager.enable {
      dependencies = ["apps.terminal"];

      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
        config.common."org.freedesktop.impl.portal.FileChooser" = ["termfilechooser"];
      };
      hm.xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = lib.generators.toINI {} {
        filechooser.env = "TERMCMD=kitty --class termfilechooser";
      };
      desktop.hyprland.settings.windowrule = ["match:class termfilechooser, float true"];

      theme.stylix.hmTargets.yazi.enable = false;

      hm.programs.yazi = {
        enable = true;
        shellWrapperName = "y";

        extraPackages = [pkgs.ouch];
        plugins = {inherit (pkgs.yaziPlugins) bookmarks mount ouch smart-filter;};

        theme.flavor.dark = "theme";
        theme.flavor.light = "theme";

        settings = {
          mgr = {
            ratio = [1 2 4];
            sort_by = "natural";
            show_hidden = true;
            scrolloff = 9;
          };
          preview = {
            max_width = 1200;
            max_height = 1600;
            image_filter = "lanczos3";
            image_quality = 90;
          };
          plugin.prepend_previewers = lib.singleton {
            mime = "application/{*zip,tar,bzip2,7z*,rar,xz,zstd,java-archive}";
            run = "ouch --archive-icon=' ' --show-file-icons";
          };
        };

        initLua = ''
          require("bookmarks"):setup({
          	last_directory = { enable = true, mode = "jump" },
          	show_keys = true,
          })
        '';

        keymap.mgr.prepend_keymap = [
          {
            on = "<Esc>";
            run = ["escape" "unyank"];
            desc = "Exit visual mode, clear selection, cancel search, or cancel yank";
          }
          {
            on = "d";
            run = "remove --permanently";
            desc = "Permanently delete selected files";
          }
          {
            on = ["g" "r"];
            run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
            desc = "Go to git root";
          }
          {
            on = "m";
            run = "plugin bookmarks save";
            desc = "Save current position as a bookmark";
          }
          {
            on = "'";
            run = "plugin bookmarks jump";
            desc = "Jump to a bookmark";
          }
          {
            on = ["b" "d"];
            run = "plugin bookmarks delete";
            desc = "Delete a bookmark";
          }
          {
            on = ["b" "D"];
            run = "plugin bookmarks delete_all";
            desc = "Delete all bookmarks";
          }
          {
            on = "M";
            run = "plugin mount";
            desc = "Mount";
          }
          {
            on = "C";
            run = "plugin ouch tar.gz";
            desc = "Compress";
          }
          {
            on = "F";
            run = "plugin smart-filter";
            desc = "Smart filter";
          }
        ];
      };
    };
  };
}
