{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  options.desktop.clipse.enable = mkEnableOption "clipse";

  config = mkIf config.desktop.clipse.enable {
    dependencies = ["apps.kitty"];

    hm.home.packages = with pkgs; [wl-clipboard clipse];

    core.impermanence.hm.files = [".config/clipse/clipboard_history.json"];

    desktop.hyprland.settings = {
      exec-once = ["clipse -listen"];
      windowrule = ["float, class:clipse" "size 954 534, class:clipse"];
      bind = ["Super, V, exec, kitty --class clipse -e 'clipse'"];
    };

    hm.xdg.configFile."clipse/custom_theme.json".text = lib.generators.toJSON {} (let
      inherit (config.os.lib.stylix.colors.withHashtag) base04 base05 base08 base0A base0D;
    in {
      useCustomTheme = true;
      TitleFore = base08;
      TitleInfo = base05;
      NormalTitle = base05;
      DimmedTitle = base04;
      SelectedTitle = base0A;
      NormalDesc = base04;
      DimmedDesc = base04;
      SelectedDesc = base0A;
      StatusMsg = base05;
      PinIndicatorColor = base05;
      SelectedBorder = base0A;
      SelectedDescBorder = base0A;
      FilteredMatch = base05;
      FilterPrompt = base05;
      FilterInfo = base05;
      FilterText = base05;
      FilterCursor = base05;
      HelpKey = base0A;
      HelpDesc = base05;
      PageActiveDot = base0A;
      PageInactiveDot = base04;
      DividerDot = base04;
      PreviewedText = base05;
      PreviewBorder = base0D;
    });
  };
}
