{
  lib,
  wlib,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "rg" "enable"] ["wrappers" "rg" "enable"])];

  flake.wrappers.rg = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = pkgs.ripgrep;

    addFlag = [
      "--smart-case"
      "--glob=!.git/*"
      "--hidden"
      "--max-columns=100"
      "--max-columns-preview"
    ];
  };
}
