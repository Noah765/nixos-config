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

      config = lib.mkIf config.theming.enable {
        environment.systemPackages = with self.packages.${pkgs.stdenv.system}; [switch-theme theme-switcher];

        hm.home.file.".theme-config".force = true;
        hm.home.file.".theme-config".source = "${self.packages.${pkgs.stdenv.system}.themes}/${lib.themes.default.name}";
      };
    };

    perSystem = {
      self',
      pkgs,
      ...
    }: {
      packages = {
        themes = let
          themes = lib.removeAttrs lib.themes ["default"];

          variables = lib.flip lib.concatMapAttrs themes (_: theme:
            lib.mapAttrs'
            (path: builder: lib.nameValuePair "${theme.name}/${path}" (builder.text theme pkgs))
            (lib.filterAttrs (_: builder: builder ? "text") config.theme));

          writeCommands = lib.flatten (lib.flip lib.mapAttrsToList themes (_: theme:
            lib.flip lib.mapAttrsToList config.theme (path: builder: ''
              mkdir -p ${lib.escapeShellArg (lib.dirOf "${theme.name}/${path}")}
              ${
                if builder ? "text"
                then "printenv ${lib.escapeShellArg "${theme.name}/${path}"} > ${lib.escapeShellArg "${theme.name}/${path}"}"
                else "ln -s ${lib.escapeShellArg (builder.source theme pkgs)} ${lib.escapeShellArg "${theme.name}/${path}"}"
              }
            '')));
        in
          pkgs.runCommandLocal "themes" variables ''
            mkdir -p "$out"
            cd "$out"
            ${lib.concatStrings writeCommands}
          '';

        switch-theme = pkgs.writers.writeNuBin "switch-theme" ''
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

        theme-switcher = let
          themes = lib.mapAttrsToList (_: x: x.name) (lib.removeAttrs lib.themes ["default"]);
        in
          pkgs.writers.writeNuBin "theme-switcher" ''
            "${lib.join "\\n" themes}"
            | fzf --height 0 --margin 0,1 --preview='
              let path = ls '${../wallpapers}/{r}' | shuffle | get 0.name
              ${lib.getExe pkgs.chafa} --size=($env.FZF_PREVIEW_COLUMNS)x($env.FZF_PREVIEW_LINES) $path'
            | ${lib.getExe self'.packages.switch-theme} $in
          '';
      };
    };
  };
}
