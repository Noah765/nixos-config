{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.desktop.fonts.enable = lib.mkEnableOption "configuring fonts";

    config = lib.mkIf config.desktop.fonts.enable {
      fonts.packages = [pkgs.nerd-fonts.jetbrains-mono];
      fonts.fontconfig.defaultFonts.monospace = ["JetBrainsMono Nerd Font Mono"];
    };
  };
}
