{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  inputs.qutebrowser-blocked-hosts.url = "file+https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts";
  inputs.qutebrowser-blocked-hosts.flake = false;

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
      "qutebrowser/blocked-hosts".source = inputs.qutebrowser-blocked-hosts;
      "qutebrowser/qtwebengine_dictionaries/${pkgs.hunspellDictsChromium.en-us.dictFileName}".source = pkgs.hunspellDictsChromium.en-us;
      "qutebrowser/qtwebengine_dictionaries/${pkgs.hunspellDictsChromium.de-de.dictFileName}".source = pkgs.hunspellDictsChromium.de-de;
    };

    hm.programs.qutebrowser = {
      enable = true;

      greasemonkey = [
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/master/reddit_adblock.js";
          hash = "sha256-KmCXL4GrZtwPLRyAvAxADpyjbdY5UFnS/XKZFKtg7tk=";
        })
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/master/youtube_adblock.js";
          hash = "sha256-AyD9VoLJbKPfqmDEwFIEBMl//EIV/FYnZ1+ona+VU9c=";
        })
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/master/youtube_shorts_block.js";
          hash = "sha256-e9qCSAuEMoNivepy7W/W5F9D1PJZrPAJoejsBi9ejiY=";
        })
        (pkgs.fetchurl {
          url = "https://raw.githubusercontent.com/afreakk/greasemonkeyscripts/master/youtube_sponsorblock.js";
          hash = "sha256-nwNade1oHP+w5LGUPJSgAX1+nQZli4Rhe8FFUoF5mLE=";
        })
      ];

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
          blocking.method = "hosts";
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
          (lib.getExe pkgs.nushell)
          "-c"
          (lib.join "; " [
            "yazi --cwd-file {} --chooser-file {}"
            "open {} | lines | first | if ($in | path type) == dir { $in } else { $in | path dirname } | save -f {}"
          ])
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
