{
  self,
  lib,
  ...
}: {
  nixos = {config, ...}: {
    options.cli.enable = lib.mkEnableOption "the default CLI configuration and programs";

    config.cli = lib.mkIf config.cli.enable {
      bat.enable = lib.mkDefault true;
      cd.enable = lib.mkDefault true;
      comma.enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
      editor.enable = lib.mkDefault true;
      eza.enable = lib.mkDefault true;
      fd.enable = lib.mkDefault true;
      file-manager.enable = lib.mkDefault true;
      fzf.enable = lib.mkDefault true;
      gh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      man.enable = lib.mkDefault true;
      multiplexer.enable = lib.mkDefault true;
      nix-index.enable = lib.mkDefault true;
      nom.enable = lib.mkDefault true;
      rg.enable = lib.mkDefault true;
      shell.enable = lib.mkDefault true;
      vcs-tui.enable = lib.mkDefault true;
      vcs.enable = lib.mkDefault true;
    };
  };

  flake.wrappers.cli = {pkgs, ...}: {
    imports = [self.wrapperModules.shell];

    runtimePkgs =
      map (x: {
        data = x;
        prefix = true;
      }) (with pkgs; [
        bat
        zoxide
        comma
        delta
        helix
        eza
        fd
        yazi
        fzf
        gh
        git-wrapped
        bat-extras.batman
        zellij
        nix-index
        nix-output-monitor
        ripgrep-wrapped
        jjui
        jujutsu
      ]);
  };
}
