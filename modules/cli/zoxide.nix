{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.zoxide.enable = lib.mkEnableOption "zoxide";

    config = lib.mkIf config.cli.zoxide.enable {
      wrappers.zoxide.enable = true;
      core.impermanence.hm.directories = [".local/share/zoxide"];
    };
  };

  flake.wrappers.zoxide = {pkgs, ...}: {
    imports = [lib.w.modules.default];

    package = pkgs.zoxide;

    env.SHELL = "sh";
    env._ZO_FZF_OPTS = lib.join " " [
      "--exact"
      "--no-sort"
      "--keep-right"
      "--exit-0"
      "--preview='if command -v eza >/dev/null 2>&1; then eza --tree --color always --level 2 {2..}; else ls --almost-all -C --group-directories-first --color=always {2..}; fi'"
      "--preview-window=33%,noinfo"
    ];
  };
}
