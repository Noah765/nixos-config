{
  lib,
  config,
  ...
}: {
  options.desktop.quickshell.enable = lib.mkEnableOption "Quickshell";

  config = lib.mkIf config.desktop.quickshell.enable {
    dependencies = ["desktop.hyprland" "theme.stylix"];
    hm.programs.quickshell = {
      enable = true;
      configs.default = ./.;
      systemd.enable = true;
    };
  };
}
