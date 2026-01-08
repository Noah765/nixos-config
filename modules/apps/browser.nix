{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: let
  adblockLists = [
    "https://easylist-downloads.adblockplus.org/abp-filters-anti-cv.txt"
    "https://easylist.to/easylist/easylist.txt"
    "https://easylist.to/easylist/easyprivacy.txt"
    "https://easylist.to/easylistgermany/easylistgermany.txt"
    "https://malware-filter.gitlab.io/malware-filter/urlhaus-filter-vivaldi-online.txt"
    "https://pgl.yoyo.org/adservers/serverlist.php?hostformat=adblockplus&mimetype=plaintext"
    "https://secure.fanboy.co.nz/fanboy-annoyance.txt"
    "https://ublockorigin.github.io/uAssetsCDN/filters/annoyances.min.txt"
    "https://ublockorigin.github.io/uAssetsCDN/filters/badware.min.txt"
    "https://ublockorigin.github.io/uAssetsCDN/filters/experimental.min.txt"
    "https://ublockorigin.github.io/uAssetsCDN/filters/filters.min.txt"
    "https://ublockorigin.github.io/uAssetsCDN/filters/privacy.min.txt"
    "https://ublockorigin.github.io/uAssetsCDN/filters/quick-fixes.min.txt"
    "https://ublockorigin.github.io/uAssetsCDN/filters/unbreak.min.txt"
  ];
  adblockListNames = map (x: "qutebrowser-" + lib.nameFromURL x ".") adblockLists;
in {
  inputs =
    lib.listToAttrs (map (x: {
      name = x.snd;
      value.url = "file+${x.fst}";
      value.flake = false;
    }) (lib.zipLists adblockLists adblockListNames))
    // {
      qutebrowser-greasemonkey-scripts.url = "github:afreakk/greasemonkeyscripts";
      qutebrowser-greasemonkey-scripts.flake = false;
    };

  options.apps.browser.enable = lib.mkEnableOption "qutebrowser";

  config = lib.mkIf config.apps.browser.enable {
    dependencies = ["apps.terminal" "cli.editor" "cli.fileManager"];

    desktop.hyprland.settings.bind = ["Super, B, exec, uwsm-app qutebrowser"];
    desktop.hyprland.settings.windowrule = ["float, class:qutebrowser-editor"];

    core.impermanence.hm.files = [
      ".local/share/qutebrowser/cmd-history"
      ".local/share/qutebrowser/history.sqlite"
      ".local/share/qutebrowser/state"
      ".local/share/qutebrowser/webengine/Cookies"
    ];

    hm.xdg.dataFile = {
      "qutebrowser/adblock-cache.dat".source = let
        list = pkgs.concatText "qutebrowser-adblock-list" (map (x: inputs.${x}) adblockListNames);

        builder = pkgs.writers.writePython3 "qutebrowser-adblock-cache-builder" {libraries = [pkgs.python3Packages.adblock];} ''
          import adblock
          import os

          filter_set = adblock.FilterSet()
          with open(os.environ['src']) as adblock_list:
              filter_set.add_filter_list(adblock_list.read())
          adblock.Engine(filter_set).serialize_to_file(os.environ['out'])
        '';
      in
        pkgs.runCommand "qutebrowser-adblock-cache" {src = list;} builder;

      "qutebrowser/greasemonkey".source = inputs.qutebrowser-greasemonkey-scripts;

      "qutebrowser/qtwebengine_dictionaries/${pkgs.hunspellDictsChromium.en-us.dictFileName}".source = pkgs.hunspellDictsChromium.en-us;
      "qutebrowser/qtwebengine_dictionaries/${pkgs.hunspellDictsChromium.de-de.dictFileName}".source = pkgs.hunspellDictsChromium.de-de;
    };

    hm.programs.qutebrowser = {
      enable = true;

      keyBindings = {
        normal."<Ctrl-o>" = "tab-focus stack-prev";
        normal."<Ctrl-i>" = "tab-focus stack-next";
        command."<Ctrl-p>" = "completion-item-focus --history prev";
        command."<Ctrl-n>" = "completion-item-focus --history next";
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
}
