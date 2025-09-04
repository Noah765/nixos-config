{
  lib,
  config,
  ...
}: {
  imports = [
    ./comma.nix
    ./installer.nix
    ./nushell.nix
    ./nvf
    ./ouch.nix
    ./rb.nix
    ./vcs.nix
  ];

  options.cli.enable = lib.mkEnableOption "the default CLI configuration and programs";

  config.cli = lib.mkIf config.cli.enable {
    comma.enable = lib.mkDefault true;
    nushell.enable = lib.mkDefault true;
    nvf.enable = lib.mkDefault true;
    ouch.enable = lib.mkDefault true;
    rb.enable = lib.mkDefault true;
    vcs.enable = lib.mkDefault true;
  };
}
