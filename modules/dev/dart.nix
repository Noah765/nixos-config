{
  lib,
  config,
  ...
}: {
  options.dev.dart.enable = lib.mkEnableOption "Dart";

  config = lib.mkIf config.dev.dart.enable {
    core.impermanence.hm.directories = [".pub-cache"];
    cli.vcs.jj.fix.dart.command = "dart format --stdin-name $path";
    cli.vcs.jj.fix.dart.patterns = ["glob:**/*.dart"];
  };
}
