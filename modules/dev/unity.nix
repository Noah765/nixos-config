{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.dev.unity.enable = mkEnableOption "Unity";

  config = mkIf config.dev.unity.enable {
    hm = {
      home.packages = [pkgs.unityhub];
      programs.nixvim.plugins.lsp.servers.csharp_ls.enable = true;
    };
    os.services.gnome.gnome-keyring.enable = true;
    core.impermanence.hm.directories = ["Unity" ".config/unityhub" ".config/unity3d" ".plastic4" ".local/share/keyrings"];
    desktop.hyprland.settings.bind = ["Super, U, exec, unityhub"];
  };
}
