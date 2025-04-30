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
    ./nushell.nix
    ./nvf
    ./rb.nix
  ];

  options.cli.enable = mkEnableOption "the default CLI configuration and programs";

  config.cli = mkIf config.cli.enable {
    comma.enable = mkDefault true;
    git = {
      enable = mkDefault true;
      gitHub = mkDefault true;
    };
    nushell.enable = mkDefault true;
    nvf.enable = mkDefault true;
    rb.enable = mkDefault true;
  };
}
