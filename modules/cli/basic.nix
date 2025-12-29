{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.basic = {
    enable = lib.mkEnableOption "basic cli programs";
    bat.enable = lib.mkEnableOption "bat" // {default = true;};
    eza.enable = lib.mkEnableOption "eza" // {default = true;};
    fd.enable = lib.mkEnableOption "fd" // {default = true;};
    ripgrep.enable = lib.mkEnableOption "Ripgrep" // {default = true;};
    zoxide.enable = lib.mkEnableOption "zoxide" // {default = true;};
  };

  config = lib.mkIf config.cli.basic.enable {
    hm.programs = {
      bat.enable = config.cli.basic.bat.enable;
      bat.extraPackages = [pkgs.bat-extras.batman];

      eza.enable = config.cli.basic.eza.enable;
      eza.extraOptions = [
        "--icons=auto"
        "--follow-symlinks"
        "--all"
        "--group-directories-first"
        "--ignore-glob=.jj"
        "--git-ignore"
        "--group"
        "--smart-group"
        "--total-size"
        "--git"
      ];

      fd = {
        inherit (config.cli.basic.fd) enable;
        hidden = true;
        ignores = [".git/" ".jj/"];
      };

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
      man = lib.mkIf config.cli.basic.bat.enable "batman";
      l = lib.mkIf config.cli.basic.eza.enable "eza";
      ll = lib.mkIf config.cli.basic.eza.enable "eza --long";
      lt = lib.mkIf config.cli.basic.eza.enable "eza --tree";
    };

    core.impermanence.hm.directories = lib.mkIf config.cli.basic.zoxide.enable [".local/share/zoxide"];
  };
}
