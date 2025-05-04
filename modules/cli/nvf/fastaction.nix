{
  lib,
  config,
  ...
}: {
  options.cli.nvf.fastaction.enable = lib.mkEnableOption "Fastaction";

  config.cli.nvf.settings.ui.fastaction = lib.mkIf config.cli.nvf.fastaction.enable {
    enable = true;
    setupOpts = {
      dismiss_keys = ["h" "j" "k" "l" "<Esc>"];
      keys = "abcdefgimnopqrstuvwxyz";
      popup.relative = "cursor";
    };
  };
}
