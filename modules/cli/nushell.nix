{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.cli.nushell;
in {
  options.cli.nushell.enable = mkEnableOption "nushell";

  config = mkIf cfg.enable {
    os.users.defaultUserShell = pkgs.nushell;

    hm.programs.nushell = {
      enable = true;
    };
  };
}
