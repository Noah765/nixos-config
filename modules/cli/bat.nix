{
  lib,
  wlib,
  themes,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "bat" "enable"] ["wrappers" "bat" "enable"])];

  theme.bat = theme: "--theme='${theme.bat}'";

  flake.wrappers.bat = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = pkgs.bat;

    env = {
      BAT_CONFIG_PATH = "/home/noah/.theme-config/bat";
      BAT_THEME_DARK = themes.default.bat;
      BAT_THEME_LIGHT = themes.default.bat;
    };
  };
}
