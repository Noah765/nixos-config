{
  self,
  lib,
  inputs,
  ...
}: let
  getName = isThemed: x:
    if isThemed
    then x
    else lib.removePrefix "themed-" x;

  overlay = isThemed:
    lib.composeManyExtensions (map (x: _: prev: lib.mapAttrs (_: v: self.wrappers.${getName isThemed v}.wrap {pkgs = prev;}) x) [
      {
        bat = "bat";
        delta = "delta";
        desktop-shell = "desktop-shell";
        eza = "eza";
        fd = "fd";
        ghostty = "terminal";
        git-wrapped = "git";
        helix = "themed-editor";
        jjui = "themed-vcs-tui";
        nh = "nh";
        nushell = "shell";
        ripgrep-wrapped = "rg";
      }
      {
        fzf = "themed-fzf";
        hyprland = "compositor";
        jujutsu = "vcs";
        qutebrowser = "browser";
        xdg-desktop-portal-termfilechooser = "termfilechooser";
      }
      {
        zellij-sessionizer = "multiplexer-sessionizer";
        zoxide = "cd";
      }
      {
        yazi = "themed-file-manager";
        zellij = "themed-multiplexer";
      }
      {cli = "cli";}
    ]);

  wrapperPackages = {
    bat = "bat";
    browser = "qutebrowser";
    cd = "zoxide";
    cli = "cli";
    compositor = "hyprland";
    delta = "delta";
    desktop-shell = "desktop-shell";
    editor = "helix";
    eza = "eza";
    fd = "fd";
    file-manager = "yazi";
    fzf = "fzf";
    git = "git-wrapped";
    multiplexer = "zellij";
    multiplexer-sessionizer = "zellij-sessionizer";
    nh = "nh";
    rg = "ripgrep-wrapped";
    shell = "nushell";
    termfilechooser = "xdg-desktop-portal-termfilechooser";
    terminal = "ghostty";
    vcs = "jujutsu";
    vcs-tui = "jjui";
  };
in {
  imports = [inputs.wrappers.flakeModules.default];

  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.wrappers = lib.mapAttrs (_: v: {enable = lib.mkEnableOption "the ${v} wrapper";}) self.wrappers;

    config.nixpkgs.overlays = [(overlay true)];
    config.environment.systemPackages = lib.mapAttrsToList (n: _: pkgs.${wrapperPackages.${n}}) (lib.filterAttrs (_: v: v.enable) config.wrappers);
  };

  perSystem = {pkgs, ...}: {
    nixpkgs.overlays = [(overlay false)];

    wrappers.control_type = "build";

    packages = lib.mapAttrs (_: v: pkgs.${v}) wrapperPackages;
  };
}
