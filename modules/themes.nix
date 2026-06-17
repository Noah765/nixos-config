{
  lib,
  themes,
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
    default = lib.mapAttrs (_: v: v themes.default) config.theme;
    description = "Attribute set of the contents of the files in ~/.theme-config when using the default theme.";
  };

  config.perSystem = {pkgs, ...}: {
    packages.switch-theme = let
      variables = lib.flip lib.concatMapAttrs themes (themeName: theme:
        lib.flip lib.mapAttrs' config.theme (path: builder:
          lib.nameValuePair "${themeName}/${path}" (builder theme)));

      writeCommands = lib.flatten (lib.flip lib.mapAttrsToList themes (theme: _:
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
        }
      '';
  };

  config._module.args.themes = rec {
    default = everforest;
    catppuccin = {
      fg = "#cdd6f4";
      cursor = "#f5e0dc";
      cursorText = "#11111b";
      bg = "#1e1e2e";
      selectionBg = "#353749";
      inactiveBorder = "#6c7086";
      activeBorder = "#b4befe";
      black = "#45475a";
      red = "#f38ba8";
      green = "#a6e3a1";
      yellow = "#f9e2af";
      blue = "#89b4fa";
      magenta = "#f5c2e7";
      cyan = "#94e2d5";
      white = "#a6adc8";
      brightBlack = "#585b70";
      brightRed = "#f37799";
      brightGreen = "#89d88b";
      brightYellow = "#ebd391";
      brightBlue = "#74a8fc";
      brightMagenta = "#f2aede";
      brightCyan = "#6bd7ca";
      brightWhite = "#bac2de";
      bat = "Catppuccin Mocha";
    };
    everforest = rec {
      fg = "#d3c6aa";
      cursor = fg;
      cursorText = bg;
      bg = "#2d353b";
      selectionBg = "#543a48";
      inactiveBorder = brightBlack;
      activeBorder = green;
      black = "#7a8478";
      red = "#e67e80";
      green = "#a7c080";
      yellow = "#dbbc7f";
      blue = "#7fbbb3";
      magenta = "#d699b6";
      cyan = "#83c092";
      white = fg;
      brightBlack = "#859289";
      brightRed = red;
      brightGreen = green;
      brightYellow = yellow;
      brightBlue = blue;
      brightMagenta = magenta;
      brightCyan = cyan;
      brightWhite = fg;
      bat = "base16";
    };
    gruvbox = rec {
      fg = "#ebdbb2";
      cursor = fg;
      cursorText = bg;
      bg = "#282828";
      selectionBg = "#665c54";
      inactiveBorder = brightBlack;
      activeBorder = "#d65d0e";
      black = bg;
      red = "#cc241d";
      green = "#98971a";
      yellow = "#d79921";
      blue = "#458588";
      magenta = "#b16286";
      cyan = "#689d6a";
      white = "#a89984";
      brightBlack = "#928374";
      brightRed = "#fb4934";
      brightGreen = "#b8bb26";
      brightYellow = "#fabd2f";
      brightBlue = "#83a598";
      brightMagenta = "#d3869b";
      brightCyan = "#8ec07c";
      brightWhite = fg;
      bat = "gruvbox-dark";
    };
  };
}
