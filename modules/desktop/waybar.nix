{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.desktop.waybar;
in {
  options.desktop.waybar.enable = mkEnableOption "Waybar";

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.desktop.stylix.enable;
        message = "The waybar module is dependent on the stylix module.";
      }
    ];

    hm.programs.waybar = {
      enable = true;
      # TODO systemd.enable

      settings = {
        modules-left = ["image" "hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["network" "wireplumber"];

        image.path = "/home/noah/Downloads/nix-snowflake.svg";
        "hyprland/workspaces" = {
          persistent-workspaces."*" = [1 2 3 4 5 6 7 8 9 10];
          move-to-monitor = true;
        };

        clock.format = "{:%A, %B %d, %Y (%R)}";

        network = {
          format-icons = ["󰤟" "󰤢" "󰤥" "󰤨"];
          format-wifi = "<big>{icon}</big>";
          format-ethernet = "<big></big>";
          format-disconnected = "<big>󰤭</big>";
        };

        wireplumber = {
          format = "{volume}% {icon}";
          format-muted = "";
          on-click = "helvum";
          format-icons = ["" "" ""];
        };
      };
    };
  };
}
