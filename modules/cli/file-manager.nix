{
  self,
  lib,
  inputs,
  ...
}: let
  runtimePkgs = pkgs: [pkgs.ouch];
  plugins = pkgs: {inherit (pkgs.yaziPlugins) bookmarks mount ouch smart-filter;};
in {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.file-manager.enable = lib.mkEnableOption "Yazi";

    config = lib.mkIf config.cli.file-manager.enable {
      wrappers.file-manager.enable = true;

      xdg.portal = {
        enable = true;
        extraPortals = [pkgs.xdg-desktop-portal-termfilechooser];
        config.common."org.freedesktop.impl.portal.FileChooser" = "termfilechooser";
      };
    };
  };

  theme =
    lib.flip lib.mapAttrs' self.wrappers.file-manager.settings (n: v:
      lib.nameValuePair "yazi/${n}.toml" {source = _: pkgs: (pkgs.formats.toml {}).generate "yazi-${n}.toml" v;})
    // {
      "yazi/init.lua".text = _: _: self.wrappers.file-manager.constructFiles.init.content;
      "yazi/flavors/theme.yazi".source = theme: _: inputs."file-manager-${theme.name}-theme";
      "yazi/plugins".source = _: pkgs:
        pkgs.linkFarm "yazi-plugins" (lib.mapAttrsToList (name: path: {
          name = "${name}.yazi";
          inherit path;
        }) (plugins pkgs));
    };

  flake.wrappers = {
    termfilechooser = {pkgs, ...}: {
      imports = [lib.w.modules.default];

      package = pkgs.xdg-desktop-portal-termfilechooser;
      exePath = "libexec/xdg-desktop-portal-termfilechooser";
      binDir = "libexec";

      filesToPatch = [
        "share/dbus-1/services/org.freedesktop.impl.portal.desktop.termfilechooser.service"
        "share/systemd/user/xdg-desktop-portal-termfilechooser.service"
      ];

      env.TERMCMD = "${lib.getExe pkgs.ghostty} --class=com.termfilechooser -e";
    };

    themed-file-manager = {pkgs, ...}: {
      imports = [lib.w.modules.default];
      package = pkgs.yazi;
      runtimePkgs = runtimePkgs pkgs;
      env.YAZI_CONFIG_HOME = "/home/noah/.theme-config/yazi";
    };

    file-manager = {
      pkgs,
      config,
      ...
    }: {
      imports = [lib.w.wrapperModules.yazi];

      runtimePkgs = runtimePkgs pkgs;

      flavors.theme = inputs.${lib.themes.default.fileManager};

      plugins = plugins pkgs;

      constructFiles.init.relPath = "${config.binName}-config/init.lua";
      constructFiles.init.content = ''
        require("bookmarks"):setup({
          last_directory = { enable = true, mode = "jump" },
          show_keys = true,
        })
      '';

      settings = {
        theme.flavor.dark = "theme";
        theme.flavor.light = "theme";

        yazi = {
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
            on = "u";
            run = ''shell -- FILE="$(readlink --canonicalize "%h")"; rm "%h"; cp --no-preserve=all "$FILE" "%h"'';
            desc = "Unlink";
          }
          {
            on = ["g" "r"];
            run = ''shell -- ya emit cd "$(git rev-parse --show-toplevel)"'';
            desc = "Go to git root";
          }
          {
            on = ["g" "p"];
            run = "cd ~/projects";
            desc = "Go to ~/projects";
          }
          {
            on = ["g" "n"];
            run = "cd /etc/nixos";
            desc = "Go to /etc/nixos";
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
