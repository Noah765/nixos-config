{
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [(lib.mkAliasOptionModule ["cli" "vcs" "jj" "fix"] ["hm" "programs" "jujutsu" "settings" "fix" "tools"])];

  options.cli.vcs = {
    enable = lib.mkEnableOption "Jujutsu, Git and the GitHub CLI";
    jj.enable = lib.mkEnableOption "Jujutsu" // {default = true;};
    git.enable = lib.mkEnableOption "Git" // {default = true;};
    gh.enable = lib.mkEnableOption "the GitHub CLI" // {default = true;};
  };

  config = lib.mkIf config.cli.vcs.enable {
    hm.programs = {
      jujutsu.enable = config.cli.vcs.jj.enable;
      jujutsu.settings = {
        user.name = "Noah765";
        user.email = "noah.landgraf@gmx.de";
        ui = {
          default-command = "log";
          diff-formatter = "${lib.getExe pkgs.difftastic} --color always --sort-paths $left $right";
          movement.edit = true;
          log-word-wrap = true;
          diff-editor = "vimdiff";
        };
        aliases = lib.mapAttrs (name: script: ["util" "exec" "--" (lib.getExe pkgs.nushell) (pkgs.writeText "jj-${name}" script)]) {
          push = ''
            def main [--revision (-r) = '@'] {
              jj bookmark move main -t $revision
              jj git push
            }
          '';
          gh = ''
            def main [name: string --private (-p)] {
              ${lib.getExe pkgs.gh} repo create $name (if $private { '--private' } else { '--public' })
              jj git clone $'https://github.com/Noah765/($name)'
              cd $name
              jj describe -m init
              jj bookmark create main -r @
            }
          '';
          fork = ''
            def main [owner: string repo: string] {
              ${lib.getExe pkgs.gh} repo fork $'($owner)/($repo)' --clone=false --default-branch-only
              main clone $repo --owner $owner
            }

            def "main clone" [repo: string --owner: string] {
              jj git clone $'https://github.com/Noah765/($repo)'
              cd $repo
              let owner = if $owner != null { $owner } else { ${lib.getExe pkgs.gh} repo view $repo --json parent --jq .parent.owner.login }
              jj git remote add upstream $'https://github.com/($owner)/($repo)'
              jj git fetch
              let default_branch = ${lib.getExe pkgs.gh} repo view $repo --json defaultBranchRef -q .defaultBranchRef.name
              jj bookmark track $'($default_branch)@upstream'
            }
          '';
        };
        # TODO diff editor and merge tool
        git = {
          colocate = true;
          fetch = ["origin" "upstream"];
          push-new-bookmarks = true;
        };
        fsmonitor.backend = "watchman";
      };
      git = {
        inherit (config.cli.vcs.git) enable;
        userName = "Noah765";
        userEmail = "noah.landgraf@gmx.de";
        extraConfig.init.defaultBranch = "main";
        difftastic.enable = true;
      };
      gh.enable = config.cli.vcs.gh.enable;
    };
    hm.home.packages = [pkgs.watchman];
    core.impermanence.hm.files = lib.mkIf config.cli.vcs.gh.enable [".config/gh/hosts.yml"];
  };
}
