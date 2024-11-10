{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.dev.flutter;
in {
  options.dev.flutter.enable = mkEnableOption "Flutter";

  config = mkIf cfg.enable {
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
