{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.nix.enable = lib.mkEnableOption "Nix development tools";

  config = lib.mkIf config.dev.nix.enable {
    hm.home.packages = with pkgs; [alejandra statix deadnix];
    cli.vcs.jj.fix.nix-fmt.command = [(lib.getExe pkgs.nix) "fmt"];
    cli.vcs.jj.fix.nix-fmt.patterns = ["glob:**/*.nix"];
  };
}
