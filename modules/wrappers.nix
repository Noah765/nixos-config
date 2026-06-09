{
  self,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.wrappers.flakeModules.default];

  _module.args.wlib = inputs.wrappers.lib;

  nixos.imports = lib.mapAttrsToList (_: v: v.install) self.wrappers;

  nixos.config.nixpkgs.overlays = lib.singleton (_: prev:
    lib.mapAttrs (_: v: self.wrappers.${v}.wrap {pkgs = prev;}) {
      bat = "bat";
      delta = "delta";
      desktop-shell = "desktop-shell";
      eza-wrapped = "eza";
      fd = "fd";
      fzf = "fzf";
      ghostty = "terminal";
      git-wrapped = "git";
      helix = "editor";
      jjui = "vcs-tui";
      jujutsu = "vcs";
      nushell = "shell";
      qutebrowser = "browser";
      ripgrep-wrapped = "rg";
      xdg-desktop-portal-termfilechooser = "termfilechooser";
      yazi = "file-manager";
      zellij = "multiplexer";
      zellij-sessionizer = "multiplexer-sessionizer";
      zoxide = "cd";
    });
}
