{
  lib,
  wlib,
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
      wrappers.browser.enable = true;

      desktop.hyprland.bind = [["SUPER + B" "hl.dsp.exec_raw('uwsm-app qutebrowser')"]];
      desktop.hyprland.settings.window_rule = lib.singleton {
        match.class = "com.qutebrowser-editor";
        float = true;
      };

      core.impermanence.hm.directories = [".local/share/qutebrowser/sessions"];
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
    };
  };

  flake.wrappers.browser = {
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];

    package = pkgs.qutebrowser;

    flags."--config-py" = config.constructFiles.config.path;

    constructFiles.config.relPath = "${config.binName}-config.py";
    constructFiles.config.content = let
      select-folder = pkgs.writers.writeNu "qutebrowser-select-folder" ''
        def main [file] {
          yazi --cwd-file $file --chooser-file $file
          open $file | lines | first | if ($in | path type) == dir { $in } else { $in | path dirname } | save -f $file
        }
      '';
    in ''
      config.load_autoconfig(False)

      c.colors.completion.category.bg = '#2d353b'
      c.colors.completion.category.border.bottom = '#2d353b'
      c.colors.completion.category.border.top = '#2d353b'
      c.colors.completion.category.fg = '#a7c080'
      c.colors.completion.even.bg = '#2d353b'
      c.colors.completion.fg = '#d3c6aa'
      c.colors.completion.item.selected.bg = '#859289'
      c.colors.completion.item.selected.border.bottom = '#859289'
      c.colors.completion.item.selected.border.top = '#859289'
      c.colors.completion.item.selected.fg = '#d3c6aa'
      c.colors.completion.item.selected.match.fg = '#a7c080'
      c.colors.completion.match.fg = '#a7c080'
      c.colors.completion.odd.bg = '#343f44'
      c.colors.completion.scrollbar.bg = '#2d353b'
      c.colors.completion.scrollbar.fg = '#d3c6aa'
      c.colors.contextmenu.disabled.bg = '#343f44'
      c.colors.contextmenu.disabled.fg = '#2d353b'
      c.colors.contextmenu.menu.bg = '#2d353b'
      c.colors.contextmenu.menu.fg = '#d3c6aa'
      c.colors.contextmenu.selected.bg = '#859289'
      c.colors.contextmenu.selected.fg = '#d3c6aa'
      c.colors.downloads.bar.bg = '#2d353b'
      c.colors.downloads.error.bg = '#e67e80'
      c.colors.downloads.error.fg = '#2d353b'
      c.colors.downloads.start.bg = '#a7c080'
      c.colors.downloads.start.fg = '#2d353b'
      c.colors.downloads.stop.bg = '#83c092'
      c.colors.downloads.stop.fg = '#2d353b'
      c.colors.hints.bg = '#343f44'
      c.colors.hints.fg = '#d3c6aa'
      c.colors.hints.match.fg = '#a7c080'
      c.colors.keyhint.bg = '#2d353b'
      c.colors.keyhint.fg = '#d3c6aa'
      c.colors.keyhint.suffix.fg = '#d3c6aa'
      c.colors.messages.error.bg = '#e67e80'
      c.colors.messages.error.border = '#e67e80'
      c.colors.messages.error.fg = '#2d353b'
      c.colors.messages.info.bg = '#a7c080'
      c.colors.messages.info.border = '#a7c080'
      c.colors.messages.info.fg = '#2d353b'
      c.colors.messages.warning.bg = '#d699b6'
      c.colors.messages.warning.border = '#d699b6'
      c.colors.messages.warning.fg = '#2d353b'
      c.colors.prompts.bg = '#2d353b'
      c.colors.prompts.border = '1px solid #2d353b'
      c.colors.prompts.fg = '#d3c6aa'
      c.colors.prompts.selected.bg = '#343f44'
      c.colors.prompts.selected.fg = '#d3c6aa'
      c.colors.statusbar.caret.bg = '#859289'
      c.colors.statusbar.caret.fg = '#d3c6aa'
      c.colors.statusbar.caret.selection.bg = '#859289'
      c.colors.statusbar.caret.selection.fg = '#d3c6aa'
      c.colors.statusbar.command.bg = '#2d353b'
      c.colors.statusbar.command.fg = '#d3c6aa'
      c.colors.statusbar.command.private.bg = '#343f44'
      c.colors.statusbar.command.private.fg = '#d3c6aa'
      c.colors.statusbar.insert.bg = '#a7c080'
      c.colors.statusbar.insert.fg = '#2d353b'
      c.colors.statusbar.normal.bg = '#2d353b'
      c.colors.statusbar.normal.fg = '#d3c6aa'
      c.colors.statusbar.passthrough.bg = '#83c092'
      c.colors.statusbar.passthrough.fg = '#2d353b'
      c.colors.statusbar.private.bg = '#343f44'
      c.colors.statusbar.private.fg = '#d3c6aa'
      c.colors.statusbar.progress.bg = '#a7c080'
      c.colors.statusbar.url.error.fg = '#e67e80'
      c.colors.statusbar.url.fg = '#d3c6aa'
      c.colors.statusbar.url.hover.fg = '#d3c6aa'
      c.colors.statusbar.url.success.http.fg = '#83c092'
      c.colors.statusbar.url.success.https.fg = '#a7c080'
      c.colors.statusbar.url.warn.fg = '#d699b6'
      c.colors.tabs.bar.bg = '#2d353b'
      c.colors.tabs.even.bg = '#343f44'
      c.colors.tabs.even.fg = '#d3c6aa'
      c.colors.tabs.indicator.error = '#e67e80'
      c.colors.tabs.indicator.start = '#83c092'
      c.colors.tabs.indicator.stop = '#a7c080'
      c.colors.tabs.odd.bg = '#2d353b'
      c.colors.tabs.odd.fg = '#d3c6aa'
      c.colors.tabs.pinned.even.bg = '#a7c080'
      c.colors.tabs.pinned.even.fg = '#2d353b'
      c.colors.tabs.pinned.odd.bg = '#83c092'
      c.colors.tabs.pinned.odd.fg = '#2d353b'
      c.colors.tabs.pinned.selected.even.bg = '#859289'
      c.colors.tabs.pinned.selected.even.fg = '#d3c6aa'
      c.colors.tabs.pinned.selected.odd.bg = '#859289'
      c.colors.tabs.pinned.selected.odd.fg = '#d3c6aa'
      c.colors.tabs.selected.even.bg = '#859289'
      c.colors.tabs.selected.even.fg = '#d3c6aa'
      c.colors.tabs.selected.odd.bg = '#859289'
      c.colors.tabs.selected.odd.fg = '#d3c6aa'
      c.colors.tooltip.bg = '#2d353b'
      c.colors.tooltip.fg = '#d3c6aa'
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
}
