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

    hm.programs.firefox = {
      enable = true;
      languagePacks = ["en-US" "de"];
      nativeMessagingHosts = [pkgs.tridactyl-native];
      # TODO policies
      # TODO Containers, search
      profiles.default = {
        extensions = {
          # packages = with inputs.firefox-addons.packages.${pkgs.system}; [adaptive-tab-bar-colour darkreader sidebery sponsorblock tridactyl ublock-origin youtube-shorts-block];
          packages = with inputs.firefox-addons.packages.${pkgs.system}; [darkreader sponsorblock tridactyl ublock-origin youtube-shorts-block]; # TODO DeArrow?
          force = true;
          # settings."{3c078156-979c-498b-8990-85f7987dd929}".settings = lib.importJSON "${inputs.firefox-theme}/sidebery.json";
          settings."addon@darkreader.org".settings = {
            fetchNews = false;
            theme = {
              useFont = true;
              # fontFamily = "monospace"; # TODO Control via theming system, everything is monospace?
              darkSchemeBackgroundColor = config.theme.colors.background;
              darkSchemeTextColor = config.theme.colors.foreground;
              scrollbarColor = "auto";
            };
            changeBrowserTheme = true; # TODO Modify browser theme further, control via actual browser theme (startup)
            syncSettings = false;
            # TODO enableForPDF = false;
            enableForProtectedPages = true; # TODO Adjust permissions
            # TODO enableContextMenus
            detectDarkTheme = false;
          };
          # "sponsorBlocker@ajay.app".settings.alreadyInstalled = true; TODO Disable installation window
          settings."tridactyl.vim@cmcaine.co.uk".settings.userconfig.editorcmd = "kitty --class tridactyl nvim";
        };
        settings = {
          # "browser.startup.page" = 3; # TODO
          "extensions.autoDisableScopes" = 0;
          "layout.css.prefers-color-scheme.content-override" = 0;

          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

          # Theme
          # "font.default.x-western" = "monospace";
          # "font.name.monospace.x-western" = config.theme.fonts.monospace.name;
          # "gfx.webrender.all" = true;
          # "layers.acceleration.force-enabled" = true;
          # "svg.context-properties.content.enabled" = true;
          # "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
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
        # TODO Control opacity with the theming system
        # userChrome = ''
        #   #main-window { opacity: 0.75; }
        #   #navigator-toolbox { visibility: collapse; }
        # ''; # TODO Modify hover link style?
      };
      # TODO Configure css using system theme
      # TODO Configure sidebery
    };

    core.impermanence.hm.files = lib.map (x: ".mozilla/firefox/default/${x}") ["content-prefs.sqlite" "cookies.sqlite" "favicons.sqlite" "permissions.sqlite" "places.sqlite" "sessionstore.jsonlz4" "storage.sqlite"];
    core.impermanence.hm.directories = lib.map (x: ".mozilla/firefox/default/${x}") ["extensions" "sessionstore-backups"];

    desktop.hyprland.settings.bind = ["Super, B, exec, firefox"];
    desktop.hyprland.settings.windowrule = ["float, class:tridactyl"];

    # colors theme
    hm.xdg.configFile = {
      "tridactyl/tridactylrc".text = "colors theme"; # TODO Is "colors theme" necessary to load the theme from disk, or is "theme" var enough?
      "tridactyl/themes/theme.css".text = ''
        :root {
          /* --tridactyl-font-family-sans: monospace; */
          --tridactyl-font-size: 10pt; /* fonts.size */
          --tridactyl-small-font-size: var(--tridactyl-font-size);
          --tridactyl-bg: #272E33; /* colors.background */
          --tridactyl-fg: #D3C6AA; /* colors.foreground */

          /* TODO Style status, maybe remove border? */
          /* --tridactyl-status-bg: none; */
          --tridactyl-status-border: none; /*2px #A7C080 solid; /* colors.border */
          --tridactyl-status-border-radius: 8px;

          --tridactyl-search-highlight-color: red !important; /* TODO What is this */

          --tridactyl-hintspan-fg: var(--tridactyl-fg);
          --tridactyl-hintspan-bg: var(--tridactyl-bg);
          --tridactyl-hintspan-js-background: var(--tridactyl-bg); /* TODO Elements with mouse events, maybe display differently */

          /* TODO Hints mode still changes text, e.g. GitHub file view */
          --tridactyl-hint-active-fg: none;
          --tridactyl-hint-active-bg: none;
          --tridactyl-hint-bg: none;
          --tridactyl-hint-outline: none;

          --tridactyl-cmdl-bg: var(--tridactyl-bg); /* TODO Required? */
          --tridactyl-cmdl-fg: var(--tridactyl-fg); /* TODO Required? */
          --tridactyl-cmdl-line-height: 2; /* TODO */
          --tridactyl-cmdl-font-size: var(--tridactyl-font-size);

          /* TODO */
          /* --tridactyl-cmplt-option-height: 10pt; */
          /* --tridactyl-cmplt-font-size: var(--tridactyl-font-size); */
          /* --tridactyl-cmplt-border-top: none; */

          --tridactyl-header-font-size: var(--tridactyl-font-size); /* TODO Required? */
          /* TODO --tridactyl-header-font-weight: normal; */
          /* TODO --tridactyl-header-border-bottom: none; */

          --tridactyl-url-fg: #7FBBB3; /* E.g. in options menu, colors.url */

          /* TODO Required? Does this even change anything? --tridactyl-of-fg: red !important; /* colors.activeForeground */ */
          /* TODO Same --tridactyl-of-bg: #A7C080; /* colors.activeBackground */ */

          /* TODO --tridactyl-highlight-box-{bg,fg} */

          /* TODO container colors? */
        }

        .TridactylStatusIndicator {
          padding: 4px 8px !important;
          left: 8px !important;
          right: unset !important;
          bottom: 8px !important;
          text-transform: uppercase !important;
        }

        /* TODO Style TridactylOwnNamespace, see midnight.css
        /* :root.TridactylOwnNamespace a { */
        /*   color: #3b84ef; */
        /* } */
        /**/
        /* :root.TridactylOwnNamespace code { */
        /*   background-color: #2a333c; */
        /*   padding: 3px 7px; */
        /* } */
        /**/
        /* :root #command-line-holder, */
        /* :root #tridactyl-input { */
        /*   border-radius: var(--tridactyl-border-radius) !important; */
        /* } */

        /* :root #tridactyl-colon::before { */
        /*   content: ""; */
        /* } */

        /* :root #tridactyl-input { */
        /*   width: 96%; */
        /*   padding: 1rem; */
        /* } */
        /**/
        /* :root #completions table { */
        /*   font-weight: 200; */
        /*   table-layout: fixed; */
        /*   padding: 1rem; */
        /*   padding-top: 0; */
        /* } */
        /**/
        /* :root #completions > div { */
        /*   max-height: calc(20 * var(--tridactyl-cmplt-option-height)); */
        /*   min-height: calc(10 * var(--tridactyl-cmplt-option-height)); */
        /* } */

        #completions {
          /* border: none !important; */
          /* font-family: var(--tridactyl-font-family); */
          order: 1;
          margin-top: 30px;
          /* border-radius: var(--tridactyl-border-radius); */
        }
        /**/
        /* :root #completions .HistoryCompletionSource table { */
        /*   width: 100%; */
        /*   border-spacing: 0; */
        /*   table-layout: fixed; */
        /* } */
        /**/
        /* :root #completions .BufferCompletionSource table { */
        /*   width: unset; */
        /*   font-size: unset; */
        /*   border-spacing: unset; */
        /*   table-layout: unset; */
        /* } */
        /**/
        /* :root #completions table tr .title { */
        /*   width: 50%; */
        /* } */
        /**/
        /* :root #completions tr .documentation { */
        /*   white-space: nowrap; */
        /*   overflow: auto; */
        /*   text-overflow: ellipsis; */
        /* } */
        /**/
        /* :root #completions .sectionHeader { */
        /*   background: transparent; */
        /*   padding: 1rem 1rem 0.4rem !important; */
        /* } */

        #cmdline_iframe {
          top: 64px !important;
          left: 10% !important;
          width: 80% !important;
          /* filter: drop-shadow(0px 0px 20px #000000) !important; */
          /* color-scheme: only light; /* Prevent Firefox from adding a white background on dark-mode sites */ */
          /* background-color: var(--tridactyl-bg) !important; */
        }
      '';
    };
  };
}
