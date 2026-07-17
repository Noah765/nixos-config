{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.vcs.enable = lib.mkEnableOption "Jujutsu";

    config = lib.mkIf config.cli.vcs.enable {
      wrappers.vcs.enable = true;
      core.impermanence.hm.directories = [".config/jj/repos"];
    };
  };

  flake.wrappers.vcs = {pkgs, ...}: {
    imports = [lib.w.wrapperModules.jujutsu];

    runtimePkgs = [pkgs.watchman];

    settings = {
      user.name = "Noah765";
      user.email = "noah.landgraf@gmx.de";

      ui = {
        default-command = "log";
        diff-formatter = [(lib.getExe pkgs.difftastic) "--color=always" "$left" "$right"];
        movement.edit = true;
        log-word-wrap = true;
        show-cryptographic-signatures = true;
      };

      merge-tools.inline = {
        program = lib.getExe pkgs.difftastic;
        diff-args = ["--display=inline" "--color=always" "$left" "$right"];
      };

      merge-tools.delta = {
        program = lib.getExe pkgs.delta;
        diff-args = ["--width=$width" "$left" "$right"];
        diff-expected-exit-codes = [0 1];
      };

      templates.draft_commit_description = "builtin_draft_commit_description_with_diff";
      template-aliases."format_timestamp(timestamp)" = "timestamp.ago()";
      template-aliases."format_short_signature(signature)" = "signature.name()";

      revsets.bookmark-advance-to = "heads(::@ & mutable() & ~description(exact:\"\") & (~empty() | merges()))";

      fix.tools.treefmt.command = ["treefmt" "--quiet" "--stdin" "$path"];
      fix.tools.treefmt.patterns = ["**"];

      remotes.origin.auto-track-bookmarks = "*";
      remotes.upstream.auto-track-bookmarks = "main|master";

      fsmonitor.backend = "watchman";

      aliases = lib.mapAttrs (name: script: ["util" "exec" "--" (pkgs.writers.writeNu "jj-${name}" script)]) {
        gh = ''
          def main [name: string --private (-p)] {
            ${lib.getExe pkgs.gh} repo create $name (if $private { '--private' } else { '--public' })
            jj git clone $'https://github.com/Noah765/($name)'
            cd $name
            jj describe --message init
            jj bookmark create main
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
            jj config set --repo git.fetch '["origin", "upstream"]'
            jj git fetch
          }
        '';

        clone = "def main [name: string] { jj git clone $'https://github.com/Noah765/($name)' }";

        push = ''
          def main [revision: string = '@-'] {
            jj bookmark move main --to $revision
            jj git push
          }
        '';
      };
    };
  };
}
