{
  self,
  lib,
  inputs,
  ...
}: {
  imports = [inputs.wrappers.flakeModules.default];

  _module.args.wlib = inputs.wrappers.lib;

  nixos.imports = lib.mapAttrsToList (_: v: v.install) self.wrappers;

  nixos.config.nixpkgs.overlays = lib.singleton (_: prev: {
    bat = self.wrappers.bat.wrap {pkgs = prev;};
    delta = self.wrappers.delta.wrap {pkgs = prev;};
    eza-wrapped = self.wrappers.eza.wrap {pkgs = prev;};
    fd = self.wrappers.fd.wrap {pkgs = prev;};
    fzf = self.wrappers.fzf.wrap {pkgs = prev;};
    ghostty = self.wrappers.terminal.wrap {pkgs = prev;};
    git-wrapped = self.wrappers.git.wrap {pkgs = prev;};
    helix = self.wrappers.editor.wrap {pkgs = prev;};
    jjui = self.wrappers.vcsTui.wrap {pkgs = prev;};
    jujutsu = self.wrappers.vcs.wrap {pkgs = prev;};
    nushell = self.wrappers.shell.wrap {pkgs = prev;};
    qutebrowser = self.wrappers.browser.wrap {pkgs = prev;};
    ripgrep-wrapped = self.wrappers.rg.wrap {pkgs = prev;};
    yazi = self.wrappers.fileManager.wrap {pkgs = prev;};
    zellij = self.wrappers.multiplexer.wrap {pkgs = prev;};
    zellij-sessionizer = self.wrappers.multiplexerSessionizer.wrap {pkgs = prev;};
    zoxide = self.wrappers.cd.wrap {pkgs = prev;};
  });
}
