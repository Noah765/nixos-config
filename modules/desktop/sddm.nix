{
  lib,
  inputs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.desktop.sddm;
in {
  inputs.sddm-sugar-candy.url = "github:Noah765/sddm-sugar-candy";

  osImports = [inputs.sddm-sugar-candy.nixosModules.default];

  options.desktop.sddm = {
    enable = mkEnableOption "SDDM";
    autoLogin = mkEnableOption "automatic user login";
  };

  config = mkIf cfg.enable {
    # TODO dependencies = ["core.user" "desktop.stylix"];

    os.services.displayManager = {
      autoLogin.user = mkIf cfg.autoLogin "noah";

      sddm = {
        enable = true;
        wayland.enable = true;

        sugarCandy = {
          enable = true;

          settings = let
            # inherit (config.os.lib.stylix.colors.withHashtag) base00 base05 base0D;
          in {
            # Background = config.os.stylix.image;
            FullBlur = true;
            BlurRadius = 25;
            FormPosition = "center";
            # TODO
            # MainColor = base05;
            # AccentColor = base0D;
            # BackgroundColor = base00;
            # OverrideLoginButtonTextColor = base00;
            # Font = config.os.stylix.fonts.sansSerif.name;
          };
        };
      };
    };
  };
}
