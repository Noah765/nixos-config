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

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.stylix.enable;
        message = "The sddm module is dependent on the stylix module.";
      }
    ];

    os.services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      sugarCandy.settings = with osConfig.lib.stylix.colors; {
        Background = osConfig.stylix.image;
        FullBlur = true;
        BlurRadius = 25;
        FormPosition = "center";
        MainColor = "#${base05}";
        AccentColor = "#${base0A}";
        BackgroundColor = "#${base00}";
        OverrideLoginButtonTextColor = "#${base00}";
        Font = stylix.fonts.sansSerif.name;
      };
    };
  };
}
