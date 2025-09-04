{
  lib,
  inputs,
  config,
  ...
}: {
  inputs.sddm-sugar-candy.url = "github:Noah765/sddm-sugar-candy";

  osImports = [inputs.sddm-sugar-candy.nixosModules.default];

  options.desktop.sddm = {
    enable = lib.mkEnableOption "SDDM";
    autoLogin = lib.mkEnableOption "automatic user login";
  };

  config = lib.mkIf config.desktop.sddm.enable {
    # TODO dependencies = ["core.user" "desktop.stylix"];

    os.services.displayManager = {
      autoLogin.user = lib.mkIf config.desktop.sddm.autoLogin "noah";

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
