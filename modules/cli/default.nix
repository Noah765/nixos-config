{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
  cfg = config.cli;
in {
  imports = [
    ./comma.nix
    ./fd.nix
    ./git.nix
    ./installer.nix
    ./nix.nix
    ./nixvim
    ./nushell.nix
    ./ripgrep.nix
  ];

  options.cli.enable = mkEnableOption "the default CLI configuration and programs";

  config.cli = mkIf cfg.enable {
    comma.enable = mkDefault true;
    fd.enable = mkDefault true;
    git = {
      enable = mkDefault true;
      gitHub = mkDefault true;
    };
    nix.enable = mkDefault true;
    nixvim.enable = mkDefault true;
    nushell.enable = mkDefault true;
    ripgrep.enable = mkDefault true;
  };
}
