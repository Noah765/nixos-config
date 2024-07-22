{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.desktop.stylix;
in {
  inputs.stylix = {
    url = "github:danth/stylix";
    inputs = {
      nixpkgs.follows = "nixpkgs";
      home-manager.follows = "home-manager";
    };
  };

  osImports = [inputs.stylix.nixosModules.stylix];

  options.desktop.stylix.enable = mkEnableOption "Stylix";

  config.os.stylix = mkIf cfg.enable {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

    image = pkgs.fetchurl {
      url = "https://codeberg.org/exorcist/wallpapers/raw/branch/master/gruvbox/forest-4.jpg";
      hash = "sha256-mqrwRvJmRLK3iyEiXmaw5UQPftEaqg33NhwzpZvyXws=";
    };

    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
    };

    fonts.monospace = {
      package = pkgs.nerdfonts.override {fonts = ["JetBrainsMono"];};
      name = "JetBrainsMono Nerd Font Mono";
    };
  };
}
