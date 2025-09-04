{
  lib,
  config,
  ...
}: {
  options.apps.browser.enable = lib.mkEnableOption "qutebrowser";

  config = lib.mkIf config.apps.browser.enable {
    hm.programs.qutebrowser = {
      enable = true;
      # TODO hm.programs.qutebrowser.quickmarks
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
        colors = let
          inherit (config.theme.colors) foreground background statusLineBackground selectedForeground selectedBackground matched popupForeground popupBackground popupDisabledForeground popupDisabledBackground popupSelectedForeground popupSelectedBackground progressStartForeground progressStartBackground progressFinishForeground progressFinishBackground errorForeground errorBackground nextKey previousKeys modeForeground normalMode visualMode insertMode commandMode title scrollbarTrack scrollbarHandle border;
        in {
          completion = {
            category = {
              bg = background;
              border.bottom = background;
              border.top = background;
              fg = title;
            };
            even.bg = background;
            fg = foreground;
            item.selected = {
              bg = selectedBackground;
              border.bottom = selectedBackground;
              border.top = selectedBackground;
              fg = selectedForeground;
              match.fg = matched;
            };
            match.fg = matched;
            odd.bg = background;
            scrollbar.bg =
              if scrollbarTrack == null
              then background
              else scrollbarTrack;
            scrollbar.fg = scrollbarHandle;
          };
          contextmenu = {
            disabled.bg = popupDisabledBackground;
            disabled.fg = popupDisabledForeground;
            menu.bg = popupBackground;
            menu.fg = popupForeground;
            selected.bg = popupSelectedBackground;
            selected.fg = popupSelectedForeground;
          };
          downloads = {
            bar.bg = statusLineBackground;
            error.bg = errorBackground;
            error.fg = errorForeground;
            start.bg = progressStartBackground;
            start.fg = progressStartForeground;
            stop.bg = progressFinishBackground;
            stop.fg = progressFinishForeground;
          };
          hints = {
            bg = background;
            fg = nextKey;
            match.fg = previousKeys;
          };
          keyhint = {
            bg = background;
            fg = foreground;
            suffix.fg = nextKey;
          };
          # TODO messages
          prompts = {
            bg = background;
            border = "1px sold ${border}";
            fg = foreground;
            selected.bg = selectedBackground;
            selected.fg = selectedForeground;
          };
          statusbar = {
            caret = {
              # bg = "";
              # fg = modeForeground;
              selection.bg = visualMode;
              selection.fg = modeForeground;
            };
            command = {
              bg = commandMode;
              fg = modeForeground;
              # private.bg = "";
              # private.fg = "";
            };
            insert.bg = insertMode;
            insert.fg = modeForeground;
            normal.bg = normalMode;
            normal.fg = modeForeground;
            # passthrough.bg = "";
            # passthrough.fg = "";
            # private.bg = "";
            # private.fg = "";
            progress.bg = modeForeground;
            # url = {
            #   error.fg = "";
            #   fg = "";
            #   hover.fg = "";
            #   succees.http.fg = "";
            #   success.https.fg = "";
            #   warn.fg = "";
            # };
          };
          # TODO tabs, tooltip
          webpage.bg = config.theme.colors.background; # TODO empty to use the theme's color
          # TODO webpage.darkmode
          webpage.preferred_color_scheme = "dark"; # TODO configure system-wide color scheme setting (and remove this?)
        };
        completion.height = "30%";
        # TODO completion.{scrollbar, use_best_match}
        # completion.web_history.max_items = 100; # TODO does this only affect the completions?
        confirm_quit = ["downloads"];
        # TODO content.autoplay
        # TODO Make the ABP ad blocker available if it isn't
        # TODO content.cache.maximum_pages, content.cache.size, content.cookies.accept, content.fullscreen.overlay_timeout, content.fullscreen.window
        content.headers.accept_language = "en-US,en;q=0.9,de-DE,de;q=0.8";
        # TODO content.headers.user_agent, content.hyprlink_auditing, content.javascript.{can_open_tabs_automatically, legacy_touch_events, log, log_message.levels, modal_dialog, local_content_can_access_remote_urls}
        # TODO content.notifications.presenter
        content.pdfjs = true;
        # TODO content.{plugins, proxy, tls.certificate_errors, unknown_url_scheme_policy, webrtc_ip_handling_policy, xss_auditing}
        downloads.location.remember = false;
        # TODO downloads.open_dispatcher
        downloads.remove_finished = 5000;
        # TODO editor, fileselect
        fonts.completion.category = "${lib.optionalString config.theme.bold.title "bold "}default_size default_family";
        fonts.hints = "${lib.optionalString config.theme.bold.jumpSpot "bold "}default_size default_family";
        # TODO fonts.{contextmenu, default_size, hints, keyhint, prompts, tooltip, web}
        hints.auto_follow = "always"; # TODO
        hints.border = "1px solid ${config.theme.colors.border}";
        # TODO hints.{chars, hide_unmatched_rapid_hints, leave_on_load, next_regexes, padding, prev_regexes, radius, scatter, selectors, uppercase}
        # TODO history_gap_interval
        # TODO input.forward_unbound_keys
        input.insert_mode.auto_load = true;
        # TODO input.{insert_mode.plugins, links_included_in_focus_chain, media_keys, mode_override, mouse.rocker_gestures, partial_timeout, spatial_navigation}
        # TODO keyhint, logging, messages.timeout, new_instance_open_target, new_instance_open_target_window, prompt.{filebrowser, radius}, qt.{force_platform, force_platformtheme, force_software_rendering, highdpi}
        scrolling.bar = "never";
        # TODO scrolling.smooth, search.incremental, spellcheck.languages, statusbar, tabs.{close_mouse_button_on_bar, favicons.scale, focus_stack_size, indicator}
        tabs.last_close = "default-page";
        # TODO tabs.{max_width, min_width, mode_on_change, new_position, padding, pinned, position, select_on_remove, show, show_switching_delay, title.{alignment, format, format_pinned}, tooltips, undo_stack_size, width}
        # TODO url.auto_search
        url.default_page = "https://www.ecosia.org";
        url.start_pages = "https://www.ecosia.org";
        # TODO url.{incdec_segments, open_base_url, searchengines}, window.{hide_decoration, title_format, transparent}, zoom.mouse_divider
      };
    };
    core.impermanence.hm.directories = [".local/share/qutebrowser"];
    desktop.hyprland.settings.bind = ["Super, B, exec, qutebrowser"];
  };
}
