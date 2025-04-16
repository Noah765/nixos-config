{pkgs, ...}: {
  osImports = [./hardware-configuration.nix];

  core = {
    impermanence.disk = "nvme0n1";
    networkmanager.hostName = "primary";
    nvidia.enable = true;
  };

  cli.installer.enable = true;

  desktop = {
    sddm.autoLogin = true;
    hyprland.settings.monitor = [
      "DP-1, 1920x1080@144, 0x0, 1"
      "HDMI-A-1, 1920x1080@75, 1920x0, 1"
    ];
  };

  dev = {
    unity.enable = true;
    flutter.enable = true;
  };

  apps.slack.enable = true;

  hm.home.packages = with pkgs; [
    cargo
    rustc

    protonup

    (pkgs.writeShellScriptBin "rb" "${getExe inputs.modulix.packages.${pkgs.system}.mxg} && ${getExe pkgs.nh} os $*")
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
}
