{
  self,
  lib,
  wlib,
  inputs,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "bat" "enable"] ["wrappers" "bat" "enable"])];

  flake.wrappers.bat = {pkgs, ...}: {
    imports = [wlib.modules.default];
    package = pkgs.bat;
    flags."--theme" = "theme";
    env.BAT_CACHE_PATH = "${self.packages.${pkgs.stdenv.system}.bat-cache}/bat";
  };

  perSystem = {pkgs, ...}: {
    packages.bat-cache = pkgs.stdenvNoCC.mkDerivation {
      name = "bat-cache";
      src = "${inputs.bat-theme}/Everforest Dark/Everforest Dark.tmTheme";
      unpackPhase = ''
        mkdir -p config/themes
        cp "$src" config/themes/theme.tmTheme
      '';
      buildPhase = "BAT_CONFIG_DIR=config BAT_CACHE_PATH=cache ${lib.getExe pkgs.bat} cache --build";
      installPhase = ''
        mkdir -p "$out/bat"
        cp -r cache/* "$out/bat"
      '';
    };
  };
}
