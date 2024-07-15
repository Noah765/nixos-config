{
  lib,
  inputs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = config.sddm;
in
{
  inputs.sddm-sugar-candy.url = "github:Noah765/sddm-sugar-candy";

  osImports = [ inputs.sddm-sugar-candy.nixosModules.default ];

  options.sddm.enable = mkEnableOption "sddm";

  config = {
    assertions = [
      {
        assertion = config.stylix.enable;
        message = "The sddm module is dependent on the stylix module.";
      }
    ];

    os.services.displayManager.sddm = mkIf cfg.enable {
      enable = true;
      wayland.enable = true;
      sugarCandy.settings =
        let
          stylix = osConfig.stylix;
          colors = osConfig.lib.stylix.colors;
        in
        {
          Background = stylix.image;
          FullBlur = true;
          BlurRadius = 25;
          FormPosition = "center";
          MainColor = "#${colors.base05}";
          AccentColor = "#${colors.base0A}";
          BackgroundColor = "#${colors.base00}";
          OverrideLoginButtonTextColor = "#${colors.base00}";
          Font = stylix.fonts.sansSerif.name;
        };
    };
  };
}
