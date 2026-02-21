{
  lib,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.apps.browser.enable = lib.mkEnableOption "qutebrowser";

    config = lib.mkIf config.apps.browser.enable {
      dependencies = ["apps.terminal" "cli.editor" "cli.fileManager"];

      desktop.hyprland.settings.bind = ["Super, B, exec, uwsm-app qutebrowser"];
      desktop.hyprland.settings.windowrule = ["match:class qutebrowser-editor, float true"];

      core.impermanence.hm.files = [
        {
          file = ".local/share/qutebrowser/cmd-history";
          method = "symlink";
        }
        ".local/share/qutebrowser/history.sqlite"
        ".local/share/qutebrowser/state"
        ".local/share/qutebrowser/webengine/Cookies"
      ];

      hm.xdg.dataFile = {
        "qutebrowser/adblock-cache.dat".source =
          pkgs.runCommand "qutebrowser-adblock-cache" {
            srcs = map (x: "${inputs.ublock-origin-assets}/${x}") [
              "filters/annoyances-cookies.txt"
              "filters/annoyances-others.txt"
              "filters/badware.txt"
              "filters/filters.txt"
              "filters/privacy.txt"
              "filters/quick-fixes.txt"
              "filters/unbreak.txt"
              "thirdparties/easylist/easylist-annoyances.txt"
              "thirdparties/easylist/easylist.txt"
              "thirdparties/easylist/easyprivacy.txt"
              "thirdparties/pgl.yoyo.org/as/serverlist"
              "thirdparties/urlhaus-filter/urlhaus-filter-online.txt"
            ];
          } (
            pkgs.writers.writePython3 "qutebrowser-adblock-cache-builder" {libraries = [pkgs.python3Packages.adblock];} ''
              import adblock
              import os

              filter_set = adblock.FilterSet()

              for file in os.environ['srcs'].split(' '):
                  with open(file) as filter_list:
                      filter_set.add_filter_list(filter_list.read())

              adblock.Engine(filter_set).serialize_to_file(os.environ['out'])
            ''
          );

        "qutebrowser/greasemonkey".source = inputs.greasemonkey-scripts;

        "qutebrowser/qtwebengine_dictionaries/${pkgs.hunspellDictsChromium.en-us.dictFileName}".source = pkgs.hunspellDictsChromium.en-us;
        "qutebrowser/qtwebengine_dictionaries/${pkgs.hunspellDictsChromium.de-de.dictFileName}".source = pkgs.hunspellDictsChromium.de-de;
      };

      hm.programs.qutebrowser = {
        enable = true;

        keyBindings.normal = {
          "<Ctrl-o>" = "tab-focus stack-prev";
          "<Ctrl-i>" = "tab-focus stack-next";
        };
        keyBindings.command = {
          "<Ctrl-p>" = "completion-item-focus --history prev";
          "<Ctrl-n>" = "completion-item-focus --history next";
        };

        searchEngines = {
          DEFAULT = "https://www.ecosia.org/search?q={}";
          g = "https://www.google.com/search?q={}";
          gh = "https://github.com/search?q={}&s=stars";
          np = "https://search.nixos.org/packages?channel=unstable&query={}";
          nw = "https://wiki.nixos.org/w/index.php?search={}";
          w = "https://en.wikipedia.org/w/index.php?search={}";
          y = "https://www.youtube.com/results?search_query={}";
        };

        settings = {
          completion = {
            scrollbar.width = 0;
            use_best_match = true;
            web_history.max_items = 100000;
          };
          confirm_quit = ["downloads"];
          content = {
            fullscreen.overlay_timeout = 0;
            headers.accept_language = "en-US,en;q=0.9,de-DE,de;q=0.8";
            local_content_can_access_remote_urls = true;
            tls.certificate_errors = "block";
          };
          downloads.location.remember = false;
          downloads.remove_finished = 5000;
          editor.command = ["kitty" "--class=qutebrowser-editor" "hx" "{file}:{line}:{column}"];
          fileselect.folder.command = [
            "kitty"
            "--class=termfilechooser"
            (toString (pkgs.writers.writeNu "qutebrowser-select-folder" ''
              yazi --cwd-file {} --chooser-file {}
              open {} | lines | first | if ($in | path type) == dir { $in } else { $in | path dirname } | save -f {}
            ''))
          ];
          hints.chars = "abcdefghijklmnopqrstuvwxyz";
          scrolling.bar = "never";
          spellcheck.languages = ["en-US" "de-DE"];
          tabs.last_close = "startpage";
          url = {
            default_page = "https://www.ecosia.org";
            open_base_url = true;
            start_pages = "https://www.ecosia.org";
          };
        };
      };
    };
  };
}
