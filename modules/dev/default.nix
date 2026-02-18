{
  lib,
  config,
  ...
}: {
  imports = [
    ./basic.nix
    ./codex.nix
    ./dart.nix
    ./java.nix
    ./markdown.nix
    ./nix.nix
    ./nu.nix
    ./qml.nix
    ./rust.nix
    ./typst.nix
    ./unity.nix
  ];

  options.dev.enable = lib.mkEnableOption "the default development tools";

  config.dev = lib.mkIf config.dev.enable {
    basic.enable = lib.mkDefault true;
    markdown.enable = lib.mkDefault true;
    nix.enable = lib.mkDefault true;
  };
}
