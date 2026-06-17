{
  lib,
  wlib,
  ...
} @ flake: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "delta" "enable"] ["wrappers" "delta" "enable"])];

  theme."delta.gitconfig" = theme: let
    toParts = x: map lib.fromHexString (lib.match "#(..)(..)(..)" x);
    round = x:
      if x - lib.floor x < 0.5
      then lib.floor x
      else lib.ceil x;
    interpolate = a: b: p: "#" + lib.concatStrings (lib.zipListsWith (a: b: lib.toHexString (round (a + (b - a) * p))) (toParts a) (toParts b));
  in
    lib.generators.toGitINI {
      delta = {
        dark = true;
        hunk-header-decoration-style = "${theme.inactiveBorder} ul ol";
        hunk-header-file-style = "bold";
        inline-hint-style = theme.inlineHint;
        line-numbers-minus-style = "red bold";
        line-numbers-plus-style = "green bold";
        line-numbers-zero-style = theme.lineNumber;
        minus-emph-style = "bold syntax ${interpolate theme.bg theme.red 0.35}";
        minus-style = "syntax ${interpolate theme.bg theme.red 0.2}";
        plus-emph-style = "bold syntax ${interpolate theme.bg theme.green 0.35}";
        plus-style = "syntax ${interpolate theme.bg theme.green 0.2}";
        syntax-theme = theme.bat;
      };
    };

  flake.wrappers.delta = {
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];

    package = pkgs.delta;

    flags."--config" = config.constructFiles.config.path;

    constructFiles.config.relPath = "${config.binName}-config";
    constructFiles.config.content =
      lib.generators.toGitINI {
        include.path = "~/.theme-config/delta.gitconfig";

        delta = {
          file-style = "omit";
          hunk-header-style = "file syntax";
          hunk-label = lib.fromJSON ''"\u00a0"'';
          line-numbers-left-format = "{nm:>3} ";
          line-numbers-right-format = "{np:>3} ";
          navigate = true;
          side-by-side = true;
          tabs = 4;
          wrap-right-percent = 99;
          wrap-right-prefix-symbol = "↪";
          wrap-right-symbol = " ";
        };
      }
      + flake.config.defaultTheme."delta.gitconfig";
  };
}
