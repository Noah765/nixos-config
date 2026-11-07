{lib, ...}: {
  nixos = {config, ...}: {
    options.cli.claude-code.enable = lib.mkEnableOption "Claude Code";

    config = lib.mkIf config.cli.claude-code.enable {
      wrappers.claude-code.enable = true;
      core.impermanence.hm.files = [".claude.json"];
      core.impermanence.hm.directories = [".claude"];
    };
  };

  flake.wrappers.claude-code = {pkgs, ...}: {
    imports = [lib.w.wrapperModules.claude-code];
    runtimePkgs = [pkgs.python3];
  };
}
