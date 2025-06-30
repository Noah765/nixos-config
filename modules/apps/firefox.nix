{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
in {
  inputs = {
    firefox-addons.url = "gitlab:rycee/nur-expressions?dir=pkgs/firefox-addons";
    firefox-addons.inputs.nixpkgs.follows = "nixpkgs";
    firefox-theme.url = "github:scientiac/scifox/immersive";
    firefox-theme.flake = false;
  };

  options.apps.firefox.enable = mkEnableOption "Firefox";

  config = mkIf config.apps.firefox.enable {
    dependencies = ["apps.kitty"];

    hm = {
      programs.firefox = {
        enable = true;
        languagePacks = ["en-US" "de"];
        nativeMessagingHosts = [pkgs.tridactyl-native];
        # TODO policies
        # TODO Containers, search
        profiles.default.extensions = {
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [adaptive-tab-bar-colour darkreader sidebery sponsorblock tridactyl ublock-origin youtube-shorts-block];
          force = true;
          settings."{3c078156-979c-498b-8990-85f7987dd929}".settings = lib.importJSON "${inputs.firefox-theme}/sidebery.json";
        };
        profiles.default.settings = {
          "browser.startup.page" = 3;
          "extensions.autoDisableScopes" = 0;
          "layout.css.prefers-color-scheme.content-override" = 0;

          # Theme
          "font.default.x-western" = "monospace";
          "font.name.monospace.x-western" = "";
          "gfx.webrender.all" = true;
          "layers.acceleration.force-enabled" = true;
          "svg.context-properties.content.enabled" = true;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # TODO browser.startup.preXulSkeletonUI

          # Theme
          # "uc.tweak.hide-tabs-bar" = true;
          # "uc.tweak.hide-forward-button" = true;
          # "uc.tweak.rounded-corners" = true;
          # "uc.tweak.floating-tabs" = true;
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          # "svg.context-properties.content.enabled" = true;
          # "layout.css.color-mix.enabled" = true;
          # "layout.css.light-dark.enabled" = true;
          # "layout.css.has-selector.enabled" = true;
          # "af.edgyarc.minimal-navbar" = true;
        };
        # TODO Configure css using system theme
        # TODO Configure sidebery
      };

      xdg.configFile."tridactyl/tridactylrc".text = "set editorcmd kitty --class tridactyl nvim"; # TODO Theme
      home.file.".mozilla/firefox/default/chrome".source = "${inputs.firefox-theme}/chrome";
    };
    # bind ZZ composite sanitise downloads formData passwords tridactyllocal tridactylsync; qall

    core.impermanence.hm.files = lib.map (x: ".mozilla/firefox/default/${x}") ["content-prefs.sqlite" "cookies.sqlite" "favicons.sqlite" "permissions.sqlite" "places.sqlite" "sessionstore.jsonlz4" "storage.sqlite"];
    core.impermanence.hm.directories = [".mozilla/firefox/default/sessionstore-backups"];

    desktop.hyprland.settings.bind = ["Super, B, exec, firefox"];
    desktop.hyprland.settings.windowrule = ["float, class:tridactyl"];
  };
}
