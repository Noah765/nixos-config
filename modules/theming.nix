{
  self,
  lib,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrsOf (lib.types.attrTag {
      text = lib.mkOption {
        type = lib.types.functionTo (lib.types.functionTo lib.types.str);
        description = "Text of the file.";
      };
      source = lib.mkOption {
        type = lib.types.functionTo (lib.types.functionTo lib.types.pathInStore);
        description = "Path of the source file or directory.";
      };
    });
    default = {};
    example = lib.literalExpression ''
      {
        "program1.config".text = theme: _: "--color1=''${theme.blue} --color2=''${theme.green}";
        "program2/theme".source = theme: pkgs: inputs.''${theme.program2Theme}.packages.''${pkgs.stdenv.system};
      }
    '';
    description = "Attribute set of files to link to ~/.theme-config.";
  };

  config = {
    _module.args.getDefaultTheme = pkgs: lib.mapAttrs (_: builder: builder.text lib.themes.default pkgs) config.theme;

    nixos = {
      pkgs,
      config,
      ...
    }: {
      options.theming.enable = lib.mkEnableOption "theming";

      config.hm.home.file.".theme-config" = lib.mkIf config.theming.enable {
        force = true;
        source = "${self.packages.${pkgs.stdenv.system}.themes}/default";
      };
    };

    perSystem = {
      self',
      pkgs,
      ...
    }: {
      packages.themes = let
        variables = lib.flip lib.concatMapAttrs lib.themes (themeName: theme:
          lib.mapAttrs'
          (path: builder: lib.nameValuePair "${themeName}/${path}" (builder.text theme pkgs))
          (lib.filterAttrs (_: builder: builder ? "text") config.theme));

        writeCommands = lib.flatten (lib.flip lib.mapAttrsToList lib.themes (themeName: theme:
          lib.flip lib.mapAttrsToList config.theme (path: builder: ''
            mkdir -p ${lib.escapeShellArg (lib.dirOf "${themeName}/${path}")}
            ${
              if builder ? "text"
              then "printenv ${lib.escapeShellArg "${themeName}/${path}"} > ${lib.escapeShellArg "${themeName}/${path}"}"
              else "ln -s ${lib.escapeShellArg (builder.source theme pkgs)} ${lib.escapeShellArg "${themeName}/${path}"}"
            }
          '')));
      in
        pkgs.runCommandLocal "themes" variables ''
          mkdir -p "$out"
          cd "$out"
          ${lib.concatStrings writeCommands}
        '';

      packages.switch-theme = pkgs.writers.writeNuBin "switch-theme" ''
        def main [theme: string] {
          if not ($'${self'.packages.themes}/($theme)' | path exists) {
            error make --unspanned $'The theme '($theme)' does not exist.'
          }

          rm --permanent --force ~/.theme-config
          ln -s ${self'.packages.themes}/($theme) ~/.theme-config

          if (which hyprctl | is-not-empty) { hyprctl reload }
          pkill -USR1 hx
        }
      '';
    };
  };
}
