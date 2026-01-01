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
        hints.auto_follow = "always"; # TODO
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
    desktop.hyprland.settings.bind = ["Super, B, exec, uwsm-app qutebrowser"];
  };
}
