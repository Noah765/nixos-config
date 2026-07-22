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
    options.desktop.shell.enable = lib.mkEnableOption "the desktop shell";

    config.hm.systemd.user.services.app-shell = lib.mkIf config.desktop.shell.enable {
      Unit.Description = "shell";
      Unit.After = ["graphical-session.target"];
      Service.ExecStart = lib.getExe pkgs.shell;
      Service.Restart = "on-failure";
      Install.WantedBy = ["graphical-session.target"];
    };
  };

  theme.shell.text = theme: _:
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

  flake.wrappers.shell = {pkgs, ...}: {
    imports = [lib.w.modules.default];
    package = inputs.shell.packages.${pkgs.stdenv.system}.default;
    env.SHELL_DEFAULT_OPTS = (getDefaultTheme pkgs).shell;
    env.SHELL_CONFIG_PATH = "~/.theme-config/shell";
  };
}
