{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.claude-code.enable = lib.mkEnableOption "Claude Code";

    config = lib.mkIf config.cli.claude-code.enable {
      environment.systemPackages = [pkgs.claude-code];
      core.impermanence.hm.directories = [".claude"];
    };
  };
}
