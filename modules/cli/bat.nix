{lib, ...}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "bat" "enable"] ["wrappers" "bat" "enable"])];

  theme.bat.text = theme: _: "--theme='${theme.bat}'";

  flake.wrappers.bat = {pkgs, ...}: {
    imports = [lib.w.modules.default];

    package = pkgs.bat;

    env = {
      BAT_CONFIG_PATH = "/home/noah/.theme-config/bat";
      BAT_THEME_DARK = lib.themes.default.bat;
      BAT_THEME_LIGHT = lib.themes.default.bat;
    };
  };
}
