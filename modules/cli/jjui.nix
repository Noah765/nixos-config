{
  self,
  lib,
  inputs,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "jjui" "enable"] ["wrappers" "jjui" "enable"])];

  theme."jjui/config.toml".source = _: pkgs: (pkgs.formats.toml {}).generate "jjui-config.toml" self.wrappers.jjui.settings;
  theme."jjui/themes/theme.toml".source = theme: _: inputs."jjui-${theme.name}-theme";

  flake.wrappers.themed-jjui = {
    imports = [self.wrapperModules.jjui];
    env.JJUI_CONFIG_DIR = lib.mkForce "/home/noah/.theme-config/jjui";
    constructFiles = lib.mkForce {};
  };

  flake.wrappers.jjui = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    options.settings = lib.mkOption {
      type = lib.w.types.structuredValueWith {
        nullable = false;
        typeName = "TOML";
      };
      default = {};
      description = "Configuration written to config.toml.";
    };

    config = {
      package = pkgs.jjui;

      env.JJUI_CONFIG_DIR = "${placeholder config.outputName}/${config.binName}-config";

      constructFiles.theme = {
        relPath = "${config.binName}-config/themes/theme.toml";
        content = lib.readFile inputs."jjui-${lib.themes.default.name}-theme";
      };

      constructFiles.config = {
        relPath = "${config.binName}-config/config.toml";
        builder = ''${lib.getExe' pkgs.remarshal "json2toml"} "$1" "$2"'';
        content = lib.toJSON config.settings;
      };

      settings = {
        preview = {
          show_at_start = true;
          revision_command = ["show" "--color=always" "-r=$change_id" "--tool=inline"];
          evolog_command = ["evolog" "--color=always" "-r=$commit_id" "--limit=1" "--patch" "--tool=inline"];
          oplog_command = ["op" "show" "--color=always" "$operation_id" "--tool=inline"];
          file_command = ["diff" "--color=always" "-r=$change_id" "$file" "--tool=inline"];
        };

        ui.theme = "theme";

        bindings = [
          {
            scope = "ui";
            key = "?";
            action = "ui.open_help";
          }
          {
            scope = "revisions.inline_describe";
            key = "enter";
            action = "revisions.inline_describe.accept";
          }
        ];

        actions = [
          {
            name = "diff-delta";
            scope = "revisions";
            key = "alt+d";
            lua = ''
              local out, err = jj('diff', '-r', context.change_id(), '--tool=delta')
              if err then flash({ text = err, error = true }) else diff.show(out) end
            '';
          }
          {
            name = "diff-delta-details";
            scope = "revisions.details";
            key = "alt+d";
            lua = ''
              local out, err = jj('diff', '-r', context.change_id(), '--tool=delta', 'file:' .. context.file())
              if err then flash({ text = err, error = true }) else diff.show(out) end
            '';
          }
        ];
      };
    };
  };
}
