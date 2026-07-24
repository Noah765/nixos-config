{
  self,
  lib,
  ...
}: {
  nixos = {config, ...}: {
    options.cli.enable = lib.mkEnableOption "the default CLI configuration and programs";

    config.cli = lib.mkIf config.cli.enable {
      bat.enable = lib.mkDefault true;
      batman.enable = lib.mkDefault true;
      comma.enable = lib.mkDefault true;
      delta.enable = lib.mkDefault true;
      direnv.enable = lib.mkDefault true;
      eza.enable = lib.mkDefault true;
      fd.enable = lib.mkDefault true;
      fzf.enable = lib.mkDefault true;
      gh.enable = lib.mkDefault true;
      git.enable = lib.mkDefault true;
      helix.enable = lib.mkDefault true;
      jjui.enable = lib.mkDefault true;
      jujutsu.enable = lib.mkDefault true;
      nh.enable = lib.mkDefault true;
      nix-index.enable = lib.mkDefault true;
      nix-output-monitor.enable = lib.mkDefault true;
      nushell.enable = lib.mkDefault true;
      pass.enable = lib.mkDefault true;
      ripgrep.enable = lib.mkDefault true;
      yazi.enable = lib.mkDefault true;
      zellij.enable = lib.mkDefault true;
      zoxide.enable = lib.mkDefault true;
    };
  };

  flake.wrappers.cli = {pkgs, ...}: {
    imports = [self.wrapperModules.nushell];

    runtimePkgs =
      map (x: {
        data = x;
        prefix = true;
      }) (with pkgs; [
        bat
        bat-extras.batman
        comma
        delta
        direnv
        eza
        fd
        fzf
        gh
        git-wrapped
        helix
        jjui
        jujutsu
        nh
        nix-index
        nix-output-monitor
        ripgrep-wrapped
        yazi
        zellij
        zoxide
      ]);
  };
}
