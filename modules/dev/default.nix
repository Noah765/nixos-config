{
  lib,
  config,
  ...
}: let
  inherit (lib) flip head length mapAttrs mkDefault mkEnableOption mkIf mkOption tail toList;
  inherit (lib.types) attrsOf either listOf oneOf str submodule;
in {
  imports = [
    ./basic.nix
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

  options.dev.enable = mkEnableOption "the default development tools";
  options.dev.formatters = mkOption {
    type = let
      submoduleType = submodule {
        options.fileExtension = mkOption {
          type = str;
          description = "The file extension of the files to format.";
        };
        options.command = mkOption {
          type = either str (listOf str);
          description = "The formatter command to run.";
        };
      };
    in
      attrsOf (oneOf [str (listOf str) submoduleType]);
    default = {};
    description = "Formatters to configure jj fix and Helix with.";
  };

  config = mkIf config.dev.enable {
    dev = {
      basic.enable = mkDefault true;
      markdown.enable = mkDefault true;
      nix.enable = mkDefault true;
    };

    cli.vcs.jj.fix = flip mapAttrs config.dev.formatters (language: x: {
      command = x.command or x;
      patterns = ["glob:**/*.${x.fileExtension or language}"];
    });
    cli.editor.languages = flip mapAttrs config.dev.formatters (_: x: let
      command = toList (x.command or x);
    in {
      formatter.command = head command;
      formatter.args = mkIf (length command > 1) (tail command);
      auto-format = true;
    });
  };
}
