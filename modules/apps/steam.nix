{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.apps.steam.enable = lib.mkEnableOption "Steam";

    config = lib.mkIf config.apps.steam.enable {
      programs.steam = {
        enable = true;
        extraCompatPackages = [pkgs.proton-ge-bin];
      };
      programs.gamemode.enable = true;

      core.impermanence.hm.directories = [".local/share/Steam" ".local/share/godot/app_userdata/Turing Complete"];
    };
  };
}
