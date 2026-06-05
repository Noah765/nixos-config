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
    packages.bat-cache = pkgs.runCommand "bat-cache" {} ''
      mkdir -p config/themes
      cp '${inputs.bat-theme}/Everforest Dark/Everforest Dark.tmTheme' config/themes/theme.tmTheme
      BAT_CONFIG_DIR=config BAT_CACHE_PATH=cache ${lib.getExe pkgs.bat} cache --build
      mkdir -p "$out/bat"
      cp -r cache/* "$out/bat"
    '';
  };
}
