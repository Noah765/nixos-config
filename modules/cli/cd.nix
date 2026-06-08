{
  self,
  lib,
  wlib,
  ...
}: {
  nixos = {config, ...}: {
    options.cli.cd.enable = lib.mkEnableOption "zoxide";

    config = lib.mkIf config.cli.cd.enable {
      wrappers.cd.enable = true;
      core.impermanence.hm.directories = [".local/share/zoxide"];
    };
  };

  flake.wrappers.cd = {pkgs, ...}: {
    imports = [wlib.modules.default];

    package = pkgs.zoxide.override {fzf = self.wrappers.fzf.wrap {inherit pkgs;};};

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
