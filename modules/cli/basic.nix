{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.basic = {
      enable = lib.mkEnableOption "basic cli programs";
      eza.enable = lib.mkEnableOption "eza" // {default = true;};
      fd.enable = lib.mkEnableOption "fd" // {default = true;};
      fzf.enable = lib.mkEnableOption "fd" // {default = true;};
      ripgrep.enable = lib.mkEnableOption "Ripgrep" // {default = true;};
      zoxide.enable = lib.mkEnableOption "zoxide" // {default = true;};
    };

    config = lib.mkIf config.cli.basic.enable {
      hm.programs = {
        eza.enable = config.cli.basic.eza.enable;
        eza.extraOptions = [
          "--icons"
          "--follow-symlinks"
          "--all"
          "--group-directories-first"
          "--ignore-glob=.jj"
          "--git-ignore"
          "--git"
        ];

        fd = {
          inherit (config.cli.basic.fd) enable;
          hidden = true;
          ignores = [".git/" ".jj/"];
        };

        fzf.enable = config.cli.basic.fzf.enable;
        fzf.defaultOptions = [
          "--style=full"
          "--margin=0,1"
          "--cycle"
          "--scroll-off=9"
          "--jump-labels=abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
          "--no-scrollbar"
          "--prompt='❯ '"
          "--preview-window=66%"
          "--bind=ctrl-d:preview-half-page-down"
          "--bind=ctrl-u:preview-half-page-up"
          "--bind=ctrl-w:jump"
        ];

        ripgrep.enable = config.cli.basic.ripgrep.enable;
        ripgrep.arguments = [
          "--smart-case"
          "--glob=!.git/*"
          "--hidden"
          "--max-columns=150"
          "--max-columns-preview"
        ];

        zoxide.enable = config.cli.basic.zoxide.enable;
        zoxide.options = ["--cmd=cd"];
      };

      cli.nushell.shellAliases = {
        l = lib.mkIf config.cli.basic.eza.enable "eza";
        ll = lib.mkIf config.cli.basic.eza.enable "eza --long";
        lt = lib.mkIf config.cli.basic.eza.enable "eza --tree";
      };

      core.impermanence.hm.directories = lib.mkIf config.cli.basic.zoxide.enable [".local/share/zoxide"];
    };
  };
}
