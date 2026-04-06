{
  lib,
  inputs,
  ...
}: {
  nixos = {config, ...}: {
    imports = [
      inputs.stylix.nixosModules.default
      (lib.mkAliasOptionModule ["theme" "stylix" "osTargets"] ["stylix" "targets"])
      (lib.mkAliasOptionModule ["theme" "stylix" "hmTargets"] ["hm" "stylix" "targets"])
    ];

    options.theme.stylix.enable = lib.mkEnableOption "Stylix";

    config = lib.mkIf config.theme.stylix.enable {
      stylix = {
        enable = true;
        inherit (config.theme) cursor;
        fonts = {
          inherit (config.theme.fonts) serif sansSerif monospace emoji;
          sizes = {inherit (config.theme.fontSizes) desktop applications terminal popups;};
        };
        polarity = "dark";
      };

      hm.stylix.targets.qt.standardDialogs = "xdgdesktopportal";
    };
  };
}
