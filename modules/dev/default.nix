{
  lib,
  config,
  ...
}: let
  inherit (lib) flip head mapAttrs mkDefault mkEnableOption mkIf mkOption tail toList;
  inherit (lib.types) attrsOf either listOf str;
in {
  imports = [
    ./basic.nix
    ./flutter.nix
    ./java.nix
    ./nix.nix
    ./nu.nix
    ./rust.nix
    ./typst.nix
    ./unity.nix
  ];

  options.dev = {
    enable = mkEnableOption "the default development tools";
    formatters = mkOption {
      type = attrsOf (either str (listOf str));
      default = {};
      description = "Formatters to configure jj fix and nvim with.";
    };
  };

  config = mkIf config.dev.enable {
    dev.basic.enable = mkDefault true;
    dev.nix.enable = mkDefault true;

    cli.vcs.jj.fix = flip mapAttrs config.dev.formatters (filetype: command: {
      inherit command;
      patterns = ["glob:**/*.${filetype}"];
    });
    cli.editor.formatting = {
      formatters = flip mapAttrs config.dev.formatters (_: command: {
        command = head (toList command);
        args = tail (toList command);
      });
      formattersByFt = mapAttrs (filetype: _: [filetype]) config.dev.formatters;
    };
  };
}
