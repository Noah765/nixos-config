{
  lib,
  getDefaultTheme,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.apps.qutebrowser.enable = lib.mkEnableOption "qutebrowser";

    config = lib.mkIf config.apps.qutebrowser.enable {
      wrappers.qutebrowser.enable = true;

      core.impermanence.hm.directories = [".local/share/qutebrowser/sessions"];
      core.impermanence.hm.files = [
        {
          file = ".local/share/qutebrowser/cmd-history";
          how = "symlink";
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
    };
  };

  theme."qutebrowser.py".text = theme: _: ''
    ${lib.readFile inputs."qutebrowser-${theme.name}-theme"}
    ${theme.qutebrowser or ""}
    c.colors.webpage.bg = None
  '';

  flake.wrappers.qutebrowser = {
    pkgs,
    config,
    ...
  }: {
    imports = [lib.w.modules.default];

    package = pkgs.qutebrowser;

    flags."--config-py" = config.constructFiles.config.path;

    env.QTWEBENGINE_FORCE_USE_GBM = "0"; # TODO Remove once qutebrowser uses at least Qt version 6.11.2

    constructFiles.theme = {
      relPath = "theme.py";
      content = (getDefaultTheme pkgs)."qutebrowser.py";
    };

    constructFiles.config = {
      relPath = "${config.binName}-config.py";
      content = let
        select-folder = pkgs.writers.writeNu "qutebrowser-select-folder" ''
          def main [file] {
            yazi --cwd-file $file --chooser-file $file
            open $file | lines | first | if ($in | path type) == dir { $in } else { $in | path dirname } | save -f $file
          }
        '';
      in ''
        import os

        config.load_autoconfig(False)

        if os.path.exists('/home/noah/.theme-config/qutebrowser.py'):
          config.source('/home/noah/.theme-config/qutebrowser.py')
        else:
          config.source('theme.py')

        c.colors.webpage.preferred_color_scheme = 'dark'
        c.completion.scrollbar.width = 0
        c.completion.use_best_match = True
        c.completion.web_history.max_items = 100000
        c.confirm_quit = ['downloads']
        c.content.fullscreen.overlay_timeout = 0
        c.content.headers.accept_language = 'en-US,en;q=0.9,de-DE,de;q=0.8'
        c.content.local_content_can_access_remote_urls = True
        c.content.tls.certificate_errors = 'block'
        c.downloads.location.remember = False
        c.downloads.remove_finished = 5000
        c.editor.command = ['ghostty', '--class=com.qutebrowser-editor', '-e', 'hx', '{file}:{line}:{column}']
        c.fileselect.folder.command = ['ghostty', '--class=com.termfilechooser', '-e', '${select-folder}', '{}']
        c.fonts.default_family = 'DejaVu Sans'
        c.fonts.default_size = '10pt'
        c.fonts.web.family.cursive = 'DejaVu Serif'
        c.fonts.web.family.fantasy = 'DejaVu Serif'
        c.fonts.web.family.fixed = 'JetBrainsMono Nerd Font Mono'
        c.fonts.web.family.sans_serif = 'DejaVu Sans'
        c.fonts.web.family.serif = 'DejaVu Serif'
        c.fonts.web.family.standard = 'DejaVu Sans'
        c.fonts.web.size.default = 13
        c.hints.border = '1px solid #2d353b'
        c.hints.chars = 'abcdefghijklmnopqrstuvwxyz'
        c.scrolling.bar = 'never'
        c.spellcheck.languages = ['en-US', 'de-DE']
        c.tabs.last_close = 'startpage'
        c.url.default_page = 'https://www.ecosia.org'
        c.url.open_base_url = True
        c.url.searchengines['DEFAULT'] = 'https://www.ecosia.org/search?q={}'
        c.url.searchengines['g'] = 'https://www.google.com/search?q={}'
        c.url.searchengines['gh'] = 'https://github.com/search?q={}&s=stars'
        c.url.searchengines['np'] = 'https://search.nixos.org/packages?channel=unstable&query={}'
        c.url.searchengines['nw'] = 'https://wiki.nixos.org/w/index.php?search={}'
        c.url.searchengines['w'] = 'https://en.wikipedia.org/w/index.php?search={}'
        c.url.searchengines['y'] = 'https://www.youtube.com/results?search_query={}'
        c.url.start_pages = 'https://www.ecosia.org'

        config.bind('<Ctrl-o>', 'tab-focus stack-prev', mode='normal')
        config.bind('<Ctrl-i>', 'tab-focus stack-next', mode='normal')
        config.bind('<Ctrl-p>', 'completion-item-focus --history prev', mode='command')
        config.bind('<Ctrl-n>', 'completion-item-focus --history next', mode='command')
      '';
    };
  };
}
