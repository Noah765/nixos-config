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
    ./neovim.nix
    ./git.nix
    ./nix.nix
    ./comma.nix
    ./installer.nix
  ];

  options.cli.enable = mkEnableOption "the default CLI configuration and programs";

  config.cli = mkIf cfg.enable {
    zsh.enable = mkDefault true;
    neovim.enable = mkDefault true;
    git = {
      enable = mkDefault true;
      gitHub = mkDefault true;
    };
    nix.enable = mkDefault true;
    comma.enable = mkDefault true;
  };
}
