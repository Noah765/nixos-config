{
  self,
  lib,
  getDefaultTheme,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "fzf" "enable"] ["wrappers" "fzf" "enable"])];

  theme.fzf.text = theme: _: "--color=hl:blue,fg+:-1,bg+:${theme.selectedLine},hl+:blue,info:yellow,border:${theme.inactiveBorder},label:-1,prompt:cyan,pointer:green,marker:green,spinner:magenta,header:-1:bold";

  flake.wrappers.themed-fzf = {
    imports = [self.wrapperModules.fzf];
    env.FZF_DEFAULT_OPTS_FILE = "/home/noah/.theme-config/fzf";
    theme = "";
  };

  flake.wrappers.fzf = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    options.theme = lib.mkOption {
      type = lib.types.str;
      default = (getDefaultTheme pkgs).fzf;
      description = "Theming arguments.";
    };

    config = {
      package = pkgs.fzf;

      env.FZF_DEFAULT_COMMAND = "fd --type=file";

      prefixVar = lib.singleton [
        "FZF_DEFAULT_OPTS"
        " "
        (lib.join " " [
          "--style=full"
          config.theme
          "--height=50%"
          "--popup=75%"
          "--reverse"
          "--border=none"
          "--cycle"
          "--jump-labels=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
          "--ellipsis=…"
          "--tabstop=4"
          "--no-scrollbar"
          "--prompt='❯ '"
          "--preview-window=66%,noinfo"
          "--bind=ctrl-w:jump"
          "--bind=ctrl-d:preview-half-page-down"
          "--bind=ctrl-u:preview-half-page-up"
        ])
      ];
    };
  };
}
