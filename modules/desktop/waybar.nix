{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.desktop.waybar;
in {
  options.desktop.waybar.enable = mkEnableOption "Waybar";

  config = mkIf cfg.enable {
    dependencies = ["desktop.stylix"];

    # TODO Temporarily fixes https://github.com/Alexays/Waybar/issues/3302
    os.nixpkgs.overlays = [
      (final: prev: {
        waybar = prev.waybar.overrideAttrs (old: {
          patches =
            old.patches
            or []
            ++ [
              (pkgs.writeText "waybar-patch" ''
                diff --git a/src/util/backlight_backend.cpp b/src/util/backlight_backend.cpp
                index bb102cd9..c2e9710c 100644
                --- a/src/util/backlight_backend.cpp
                +++ b/src/util/backlight_backend.cpp
                @@ -153,7 +153,7 @@ BacklightBackend::BacklightBackend(std::chrono::milliseconds interval,
                   // Connect to the login interface
                   login_proxy_ = Gio::DBus::Proxy::create_for_bus_sync(
                       Gio::DBus::BusType::BUS_TYPE_SYSTEM, "org.freedesktop.login1",
                -      "/org/freedesktop/login1/session/self", "org.freedesktop.login1.Session");
                +      "/org/freedesktop/login1/session/auto", "org.freedesktop.login1.Session");

                   udev_thread_ = [this] {
                     std::unique_ptr<udev, UdevDeleter> udev{udev_new()};
              '')
            ];
        });
      })
    ];

    hm.programs.waybar = {
      enable = true;
      # TODO systemd.enable

      settings = [
        {
          modules-left = ["image" "hyprland/workspaces"];
          modules-center = ["clock"];
          modules-right = ["network" "pulseaudio/slider"];

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
        }
      ];

      style = ''
        #pulseaudio-slider slider {
            min-width: 0px;
            min-height: 0px;
            opacity: 0;
            background-image: none;
            border: none;
            box-shadow: none;
        }
        #pulseaudio-slider trough {
            min-width: 80px;
            min-height: 10px;
            border-radius: 5px;
            background-color: black;
        }
        #pulseaudio-slider highlight {
            min-height: 10px;
            border-radius: 5px;
            background-color: green;
        }
      '';
    };
  };
}
