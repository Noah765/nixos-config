{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.apps.steam.enable = mkEnableOption "Steam";

  config = mkIf config.apps.steam.enable {
    os.programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
    # TODO Activate game mode?

    core.impermanence.hm.directories = [".local/share/Steam" ".local/share/godot/app_userdata/Turing Complete"];
  };
}
