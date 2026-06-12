{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.fonts.enable = lib.mkEnableOption "configuring fonts";

    config.fonts = lib.mkIf config.desktop.fonts.enable {
      packages = [pkgs.nerd-fonts.jetbrains-mono];
      fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font Mono"];
    };
  };
}
