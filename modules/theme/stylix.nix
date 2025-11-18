{
  lib,
  inputs,
  config,
  ...
}: {
  inputs.stylix.url = "github:nix-community/stylix";
  inputs.stylix.inputs.nixpkgs.follows = "nixpkgs";

  imports = [(lib.mkAliasOptionModule ["theme" "stylix" "osTargets"] ["os" "stylix" "targets"]) (lib.mkAliasOptionModule ["theme" "stylix" "hmTargets"] ["hm" "stylix" "targets"])];
  osImports = [inputs.stylix.nixosModules.stylix];

  options.theme.stylix.enable = lib.mkEnableOption "Stylix";

  config.os.stylix = lib.mkIf config.theme.stylix.enable {
    enable = true;
    inherit (config.theme) cursor;
    fonts = {
      inherit (config.theme.fonts) serif sansSerif monospace emoji;
      sizes = {inherit (config.theme.fontSizes) desktop applications terminal popups;};
    };
    polarity = "dark";
    image = config.theme.wallpaper;
  };
}
