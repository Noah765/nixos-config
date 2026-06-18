{lib, ...}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "eza" "enable"] ["wrappers" "eza" "enable"])];

  flake.wrappers.eza = {pkgs, ...}: {
    imports = [lib.w.modules.default];

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
