{lib, ...}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "ripgrep" "enable"] ["wrappers" "ripgrep" "enable"])];

  flake.wrappers.ripgrep = {pkgs, ...}: {
    imports = [lib.w.modules.default];

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
