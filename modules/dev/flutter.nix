{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.dev.flutter.enable = mkEnableOption "Flutter";

  config = mkIf config.dev.flutter.enable {
    hm = {
      home.packages = [pkgs.flutter];

      programs.nixvim.plugins.lsp.servers.dartls = {
        enable = true;
        settings.lineLength = 200;
      };
    };

    core.impermanence.hm.directories = [".pub-cache"];
  };
}
