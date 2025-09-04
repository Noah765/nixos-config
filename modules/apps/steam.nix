{
  lib,
  pkgs,
  config,
  ...
}: {
  options.apps.steam.enable = lib.mkEnableOption "Steam";

  config = lib.mkIf config.apps.steam.enable {
    os.programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
    };
    # TODO Activate game mode?

    core.impermanence.hm.directories = [".local/share/Steam" ".local/share/godot/app_userdata/Turing Complete"];
  };
}
