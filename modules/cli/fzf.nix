{
  lib,
  wlib,
  ...
}: {
  nixos.imports = [(lib.mkAliasOptionModule ["cli" "fzf" "enable"] ["wrappers" "fzf" "enable"])];

  flake.wrappers.fzf = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = pkgs.fzf;

    env.FZF_DEFAULT_COMMAND = "fd --type=file";

    prefixVar = lib.singleton [
      "FZF_DEFAULT_OPTS"
      " "
      (lib.join " " [
        "--style=full"
        "--color=hl:blue,fg+:-1,bg+:#343f44,hl+:blue,info:yellow,border:grey,label:-1,prompt:cyan,pointer:green,marker:green,spinner:magenta,header:#e69875"
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
}
