{
  lib,
  pkgs,
  config,
  ...
}: {
  options.dev.unity.enable = lib.mkEnableOption "Unity";

  config = lib.mkIf config.dev.unity.enable {
    hm.home.packages = [pkgs.unityhub];
    os.services.gnome.gnome-keyring.enable = true;
    core.impermanence.hm.directories = ["Unity" ".config/unityhub" ".config/unity3d" ".plastic4" ".local/share/keyrings"];
    desktop.hyprland.settings.bind = ["Super, U, exec, unityhub"];
  };
}
