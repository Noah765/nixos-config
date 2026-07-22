{
  lib,
  getDefaultTheme,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.desktop-shell.enable = lib.mkEnableOption "the desktop shell";

    config.hm.systemd.user.services.app-desktop-shell = lib.mkIf config.desktop.desktop-shell.enable {
      Unit.Description = "desktop-shell";
      Unit.After = ["graphical-session.target"];
      Service.ExecStart = lib.getExe pkgs.desktop-shell;
      Service.Restart = "on-failure";
      Install.WantedBy = ["graphical-session.target"];
    };
  };

  theme.desktop-shell.text = theme: _:
    lib.join "\n" (lib.mapAttrsToList (n: v: "${n}=${v}") {
      "--wallpapers" = ../../wallpapers/${theme.name};
      "--background-color" = theme.bg;
      "--text-color" = theme.fg;
      "--primary-color" = theme.primary;
      "--red" = theme.red;
      "--green" = theme.green;
      "--yellow" = theme.yellow;
      "--blue" = theme.blue;
      "--magenta" = theme.magenta;
      "--cyan" = theme.cyan;
      "--bar-opacity" = "0.75";
    });

  flake.wrappers.desktop-shell = {pkgs, ...}: {
    imports = [lib.w.modules.default];
    package = inputs.desktop-shell.packages.${pkgs.stdenv.system}.default;
    env.SHELL_DEFAULT_OPTS = (getDefaultTheme pkgs).desktop-shell;
    env.SHELL_CONFIG_PATH = "~/.theme-config/desktop-shell";
  };
}
