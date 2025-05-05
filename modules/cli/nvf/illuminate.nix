{
  lib,
  config,
  ...
}: {
  options.cli.nvf.illuminate.enable = lib.mkEnableOption "Illuminate";

  config.cli.nvf.settings.ui.illuminate = lib.mkIf config.cli.nvf.illuminate.enable {
    enable = true;
    setupOpts.min_count_to_highlight = 2;
  };
}
