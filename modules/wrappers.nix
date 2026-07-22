{
  self,
  lib,
  inputs,
  ...
}: let
  themed = ["fzf" "helix" "jjui" "yazi" "zellij"];
  wrapped = ["git" "ripgrep"];

  getPackageName = x:
    if lib.elem x wrapped
    then "wrapped-${x}"
    else x;

  getWrapperName = isThemed: x:
    if isThemed && lib.elem x themed
    then "themed-${x}"
    else x;

  overlay = isThemed:
    lib.composeManyExtensions (map (x: _: prev: lib.listToAttrs (map (x: lib.nameValuePair (getPackageName x) (self.wrappers.${getWrapperName isThemed x}.wrap {pkgs = prev;})) x)) [
      ["bat" "delta" "eza" "fd" "ghostty" "git" "helix" "jjui" "nh" "nushell" "ripgrep" "shell"]
      ["fzf" "hyprland" "jujutsu" "qutebrowser" "xdg-desktop-portal-termfilechooser"]
      ["zellij-sessionizer" "zoxide"]
      ["yazi" "zellij"]
      ["cli"]
    ]);
in {
  imports = [inputs.wrappers.flakeModules.default];

  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.wrappers = lib.mapAttrs (_: v: {enable = lib.mkEnableOption "the ${v} wrapper";}) self.wrappers;

    config.nixpkgs.overlays = [(overlay true)];
    config.environment.systemPackages = lib.mapAttrsToList (n: _: pkgs.${getPackageName n}) (lib.filterAttrs (_: v: v.enable) config.wrappers);
  };

  perSystem = {pkgs, ...}: {
    nixpkgs.overlays = [(overlay false)];

    wrappers.control_type = "build";

    packages = lib.mapAttrs (n: _: pkgs.${n}) (lib.filterAttrs (n: _: !lib.hasPrefix "themed-" n) self.wrappers);
  };
}
