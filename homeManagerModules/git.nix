{
  lib,
  config,
  ...
}:
with lib;
let
  cfg = config.git;
in
{
  options.git.enable = mkEnableOption "git";

  config = mkIf cfg.enable {
    programs.git = {
      enable = true;
      userName = "Noah765";
      userEmail = "noland62007@gmail.com";
    };
  };
}
