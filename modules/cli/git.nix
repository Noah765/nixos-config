{lib, ...}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "git" "enable"] ["wrappers" "git" "enable"])];

  flake.wrappers.git.imports = [lib.w.wrapperModules.git];
  flake.wrappers.git.settings.credential = {
    "https://github.com".helper = "!gh auth git-credential";
    "https://gist.github.com".helper = "!gh auth git-credential";
  };
}
