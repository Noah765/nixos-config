{
  lib,
  wlib,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "delta" "enable"] ["wrappers" "delta" "enable"])];

  flake.wrappers.delta = {
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];

    package = pkgs.delta;

    flags."--config" = config.constructFiles.config.path;

    constructFiles.config.relPath = "${config.binName}-config";
    constructFiles.config.content = lib.generators.toGitINI {
      delta = {
        dark = true;
        file-style = "omit";
        hunk-header-decoration-style = "ul ol";
        hunk-header-file-style = "bold";
        hunk-header-style = "file";
        hunk-label = lib.fromJSON ''"\u00a0"'';
        inline-hint-style = "#7a8478";
        line-numbers-left-format = "{nm:>3} ";
        line-numbers-minus-style = "red bold";
        line-numbers-plus-style = "green bold";
        line-numbers-right-format = "{np:>3} ";
        line-numbers-zero-style = "#7a8478";
        minus-emph-style = "red bold ul";
        minus-style = "red";
        navigate = true;
        plus-emph-style = "green bold ul";
        plus-style = "green";
        side-by-side = true;
        syntax-theme = "base16";
        tabs = 4;
        wrap-right-percent = 99;
        wrap-right-prefix-symbol = "↪";
        wrap-right-symbol = " ";
      };
    };
  };
}
