{
  lib,
  config,
  ...
}: let
  inherit (lib) mkDefault mkEnableOption mkIf;
in {
  imports = [
    ./comma.nix
    ./installer.nix
    ./nushell.nix
    ./nvf
    ./rb.nix
    ./vcs.nix
  ];

  options.cli.enable = mkEnableOption "the default CLI configuration and programs";

  config.cli = mkIf config.cli.enable {
    comma.enable = mkDefault true;
    nushell.enable = mkDefault true;
    nvf.enable = mkDefault true;
    rb.enable = mkDefault true;
    vcs.enable = mkDefault true;
  };
}
