{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./comma.nix
    ./git.nix
    ./installer.nix
    ./nix.nix
    ./nushell.nix
    ./nvf
  ];

  options.cli.enable = mkEnableOption "the default CLI configuration and programs";

  config.cli = mkIf config.cli.enable {
    comma.enable = mkDefault true;
    git = {
      enable = mkDefault true;
      gitHub = mkDefault true;
    };
    nix.enable = mkDefault true;
    nushell.enable = mkDefault true;
    nvf.enable = mkDefault true;
  };
}
