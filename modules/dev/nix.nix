{
  lib,
  pkgs,
  configName,
  config,
  ...
}: {
  options.dev.nix.enable = lib.mkEnableOption "Nix development tools";

  config = lib.mkIf config.dev.nix.enable {
    hm.home.packages = [(pkgs.writeShellScriptBin "nixc" "${lib.getExe pkgs.deadnix}; ${lib.getExe pkgs.statix} check")];

    cli.vcs.jj.fix.nix = {
      command = "nix fmt --quiet --quiet --quiet -- --quiet";
      patterns = ["glob:**/*.nix"];
    };

    cli.editor = {
      packages = [pkgs.nixd];
      languages.nix.auto-format = true;
      languageServers.nixd.config.nixd.formatting.command = ["alejandra"];
      languageServers.nixd.config.nixd.options.modulix.expr = "(builtins.getFlake \"/etc/nixos\").modulixConfigurations.${configName}.options";
    };
  };
}
