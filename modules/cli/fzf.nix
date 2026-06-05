{
  lib,
  wlib,
  ...
}: let
  display = "--height=50% --popup=75%";
  filePreview = "bat --force-colorization --style=default,-header {}";
  dirPreview = "eza --tree --color=always --level=2 {}";
in {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.fzf.enable = lib.mkEnableOption "fzf";

    config = lib.mkIf config.cli.fzf.enable {
      wrappers.fzf.enable = true;

      hm.home.sessionVariables = {
        FZF_CTRL_T_COMMAND = "fd";
        FZF_CTRL_T_OPTS = "${display} --preview='if [ -d {} ]; then ${dirPreview}; else ${filePreview}; fi'";

        FZF_CTRL_R_OPTS = display;

        FZF_ALT_C_COMMAND = "fd --type=directory";
        FZF_ALT_C_OPTS = "${display} --preview='${dirPreview}'";
      };

      cli.nushell.extraConfig = "source ${pkgs.runCommandLocal "fzf.nu" {} "${lib.getExe pkgs.fzf} --nushell > \"$out\""}";
    };
  };

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
        display
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
