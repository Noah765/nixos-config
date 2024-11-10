{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.dev.unity;
in {
  options.dev.unity.enable = mkEnableOption "Unity";

  config = mkIf cfg.enable {
    hm = {
      home.packages = [pkgs.unityhub];
      programs.nixvim.plugins.lsp.servers.csharp_ls.enable = true;
    };
    os.services.gnome.gnome-keyring.enable = true;
    core.impermanence.hm.directories = ["Unity" ".config/unityhub" ".config/unity3d" ".plastic4" ".local/share/keyrings"];
    desktop.hyprland.settings.bind = ["Super, U, exec, unityhub"];
  };
}
