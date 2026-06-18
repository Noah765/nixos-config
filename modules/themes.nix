{
  lib,
  config,
  ...
}: {
  options.theme = lib.mkOption {
    type = lib.types.attrsOf lib.types.anything;
    default = {};
    description = "Attribute set of file content builder functions for files to be linked to ~/.theme-config.";
  };
  options.defaultTheme = lib.mkOption {
    type = lib.types.attrsOf lib.types.str;
    readOnly = true;
    default = lib.mapAttrs (_: v: v lib.themes.default) config.theme;
    description = "Attribute set of the contents of the files in ~/.theme-config when using the default theme.";
  };

  config.perSystem = {pkgs, ...}: {
    packages.switch-theme = let
      variables = lib.flip lib.concatMapAttrs lib.themes (themeName: theme:
        lib.flip lib.mapAttrs' config.theme (path: builder:
          lib.nameValuePair "${themeName}/${path}" (builder theme)));

      writeCommands = lib.flatten (lib.flip lib.mapAttrsToList lib.themes (theme: _:
        lib.flip lib.mapAttrsToList config.theme (path: _: ''
          mkdir -p ${lib.escapeShellArg (lib.dirOf "${theme}/${path}")}
          printenv ${lib.escapeShellArg "${theme}/${path}"} > ${lib.escapeShellArg "${theme}/${path}"}
        '')));

      themeDir = pkgs.runCommandLocal "themes" variables ''
        mkdir -p "$out"
        cd "$out"
        ${lib.concatStrings writeCommands}
      '';
    in
      pkgs.writers.writeNuBin "switch-theme" ''
        def main [theme: string] {
          if not ($'${themeDir}/($theme)' | path exists) {
            error make --unspanned $'The theme '($theme)' does not exist.'
          }

          rm --permanent --force ~/.theme-config
          ln -s ${themeDir}/($theme) ~/.theme-config

          if (which hyprctl | is-not-empty) { hyprctl reload }
          pkill -USR1 hx
        }
      '';
  };
}
