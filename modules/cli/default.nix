{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.cli;
in {
  imports = [
    ./zsh.nix
    ./git.nix
    ./ripgrep.nix
    ./fd.nix
    ./nixvim
    ./nix.nix
    ./comma.nix
    ./installer.nix
  ];

  options.cli.enable = mkEnableOption "the default CLI configuration and programs";

  config.cli = mkIf cfg.enable {
    zsh.enable = mkDefault true;
    git = {
      enable = mkDefault true;
      gitHub = mkDefault true;
    };
    ripgrep.enable = mkDefault true;
    fd.enable = mkDefault true;
    nixvim.enable = mkDefault true;
    nix.enable = mkDefault true;
    comma.enable = mkDefault true;
  };
}
