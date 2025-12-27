{
  lib,
  config,
  ...
}: {
  imports = [
    ./basic.nix
    ./comma.nix
    ./editor.nix
    ./installer.nix
    ./nushell.nix
    ./ouch.nix
    ./rb.nix
    ./vcs.nix
  ];

  options.cli.enable = lib.mkEnableOption "the default CLI configuration and programs";

  config.cli = lib.mkIf config.cli.enable {
    basic.enable = lib.mkDefault true;
    comma.enable = lib.mkDefault true;
    editor.enable = lib.mkDefault true;
    nushell.enable = lib.mkDefault true;
    ouch.enable = lib.mkDefault true;
    rb.enable = lib.mkDefault true;
    vcs.enable = lib.mkDefault true;
  };
}
