{
  lib,
  wlib,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "eza" "enable"] ["wrappers" "eza" "enable"])];

  flake.wrappers.eza = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = pkgs.eza;

    addFlag = [
      "--across"
      "--icons"
      "--all"
      "--ignore-glob=.jj"
      "--git-ignore"
      "--group-directories-first"
      "--group"
      "--git"
    ];
  };
}
