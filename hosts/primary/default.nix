{pkgs, ...}: {
  # TODO Disable global flake registry?

  osImports = [./hardware-configuration.nix];

  core = {
    charachorder.enable = true;
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "primary";
    nvidia.enable = true;
  };

  cli.installer.enable = true;

  desktop.hyprland.settings.monitor = ["DP-1, 1920x1080@144, 0x0, 1" "HDMI-A-1, 1920x1080@75, 1920x0, 1"];

  dev.flutter.enable = true;
  dev.rust.enable = true;

  apps.slack.enable = true;
  apps.steam.enable = true;

  hm.home.packages = with pkgs; [
    prismlauncher

    discord
  ];

  core.impermanence.hm.directories = [".local/share/PrismLauncher" ".config/discord"];

  core.user.groups = ["dialout"];

  desktop.hyprland.settings.bind = ["Super, M, exec, prismlauncher" "Super, D, exec, discord"];

  os.console.enable = false; # TODO
}
