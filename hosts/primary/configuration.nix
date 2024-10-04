{pkgs, ...}: {
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "primary";
    nvidia.enable = true;
  };

  cli.installer.enable = true;

  desktop.hyprland.settings.monitor = [
    "DP-1, 1920x1080@144, 0x0, 1"
    "HDMI-A-1, 1920x1080@75, 1920x0, 1"
  ];

  hm.home.packages = with pkgs; [
    cargo
    rustc
    gcc

    flutter

    protonup
  ];

  os.programs = {
    steam.enable = true;
    steam.gamescopeSession.enable = true;
    gamemode.enable = true;
  };
  hm.home.sessionVariables.STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\${HOME}/.steam/root/compatibilitytools.d";
  core.impermanence.hm.directories = [
    {
      directory = ".local/share/Steam";
      method = "symlink";
    }
  ];

  desktop.hyprland.settings.bind = ["Super, S, exec, steam"];
}
