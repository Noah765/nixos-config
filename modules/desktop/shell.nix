{
  lib,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.shell.enable = lib.mkEnableOption "the desktop shell";

    config = lib.mkIf config.desktop.shell.enable {
      hm.systemd.user.services.app-shell = {
        Unit.Description = "shell";
        Unit.After = ["graphical-session.target"];
        Service.ExecStart = lib.join " " [
          (lib.getExe inputs.shell.packages.${pkgs.stdenv.system}.default)
          "--wallpaper-background=${config.theme.wallpaper.background}"
          "--wallpaper-middle-ground=${config.theme.wallpaper.middleGround}"
          "--wallpaper-foreground=${config.theme.wallpaper.foreground}"
          "--background-color=${config.theme.colors.base00}"
          "--text-color=${config.theme.colors.base05}"
          "--primary-color=${config.theme.colors.green}"
          "--red=${config.theme.colors.red}"
          "--green=${config.theme.colors.green}"
          "--yellow=${config.theme.colors.yellow}"
          "--blue=${config.theme.colors.blue}"
          "--magenta=${config.theme.colors.magenta}"
          "--cyan=${config.theme.colors.cyan}"
          "--bar-opacity=${lib.toString config.theme.windowOpacity}"
        ];
        Service.Restart = "on-failure";
        Install.WantedBy = ["graphical-session.target"];
      };

      desktop.hyprland.settings.layer_rule = lib.mkIf (config.theme.windowOpacity != 1) (lib.singleton {
        match.namespace = "shell-(bar|calculator)";
        blur = true;
        ignore_alpha = 0;
      });
    };
  };
}
