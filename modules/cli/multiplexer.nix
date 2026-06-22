{
  self,
  lib,
  inputs,
  ...
}: let
  switch = pkgs: lib.getExe' inputs.zellij-switch.packages.${pkgs.stdenv.system}.default "zellij-switch.wasm";
in {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.multiplexer.enable = lib.mkEnableOption "Zellij";

    config = lib.mkIf config.cli.multiplexer.enable {
      wrappers.multiplexer.enable = true;
      wrappers.multiplexer-sessionizer.enable = true;

      hm.home.file.".cache/zellij/permissions.kdl".text = ''
        "${pkgs.zellijPlugins.zjstatus}" { ReadApplicationState; ChangeApplicationState; RunCommands; }
        "${switch pkgs}" { ReadApplicationState; ChangeApplicationState; }
      '';

      core.impermanence.hm.directories = [".cache/zellij/contract_version_1/session_info"];
    };
  };

  theme."zellij/config.kdl".text = theme: pkgs:
    lib.hm.generators.toKDL {}
    ((self.wrappers.multiplexer.apply {inherit pkgs;}).settings // {theme = theme.multiplexer;});
  theme."zellij/layouts/default.kdl".text = _: _: self.wrappers.multiplexer.constructFiles.layout.content;

  flake.wrappers = {
    multiplexer-sessionizer = {pkgs, ...}: {
      imports = [lib.w.modules.default];

      package = inputs.zellij-sessionizer;
      exePath = "zellij-sessionizer";
      binName = "zellij-sessionizer";

      runtimePkgs = [pkgs.fzf];

      env = {
        ZELLIJ_SESSIONIZER_SEARCH_PATHS.data = "$HOME/projects";
        ZELLIJ_SESSIONIZER_SEARCH_PATHS.esc-fn = x: "\"${x}\"";
        ZELLIJ_SESSIONIZER_SPECIFIC_PATHS = "/etc/nixos";
        ZELLIJ_SESSIONIZER_SWITCH_PLUGIN = "file:${switch pkgs}";
      };
    };

    themed-multiplexer = {
      imports = [self.wrapperModules.multiplexer];
      flags."--config" = lib.mkForce "/home/noah/.theme-config/zellij/config.kdl";
      constructFiles = lib.mkForce {};
    };

    multiplexer = {
      pkgs,
      config,
      ...
    }: {
      imports = [lib.w.modules.default];

      options.settings = lib.mkOption {
        default = {};
        description = "Configuration to be written to config.kdl.";
      };
      options.layout = lib.mkOption {
        default = {};
        description = "Layout to be written to layouts/default.kdl.";
      };

      config = {
        package = pkgs.zellij;

        flags."--config" = "${placeholder config.outputName}/${config.binName}-config.kdl";

        constructFiles.config = {
          relPath = "${config.binName}-config.kdl";
          content = lib.hm.generators.toKDL {} config.settings;
        };
        constructFiles.layout = {
          relPath = "layouts/default.kdl";
          content = lib.hm.generators.toKDL {} config.layout;
        };

        settings = {
          pane_frames = false;
          theme = lib.themes.default.multiplexer;
          copy_on_select = false;
          layout_dir = "${placeholder config.outputName}/layouts";
          serialization_interval = 10;
          show_startup_tips = false;
          show_release_notes = false;
          mouse_hover_effects = false;

          ui.pane_frames.rounded_corners = true;

          plugins.zjstatus._props.location = "file:${pkgs.zellijPlugins.zjstatus}";

          keybinds._props.clear-defaults = true;
          keybinds._children = let
            shared_except = args: children: {
              shared_except._args = args;
              shared_except._children = children;
            };
            mode = mode: children: {${mode}._children = children;};
            bind = key: child: {bind = {_args = [key];} // child;};
            bindNormal = key: child: bind key (child // {SwitchToMode = "normal";});
          in [
            (shared_except ["locked"] [
              (bind "Ctrl Shift g" {SwitchToMode = "locked";})

              (bind "Ctrl Alt c" {Copy = {};})

              (bind "Ctrl Alt f" {ToggleFloatingPanes = {};})

              (bind "Ctrl Alt n" {NewPane = {};})
              (bind "Ctrl Alt s" {NewPane = "down";})
              (bind "Ctrl Alt v" {NewPane = "right";})
              (bind "Ctrl Alt a" {NewPane = "stacked";})
              (bind "Ctrl Alt h" {MoveFocusOrTab = "left";})
              (bind "Ctrl Alt j" {MoveFocus = "down";})
              (bind "Ctrl Alt k" {MoveFocus = "up";})
              (bind "Ctrl Alt l" {MoveFocusOrTab = "right";})
              (bind "Ctrl Shift h" {MovePane = "left";})
              (bind "Ctrl Shift j" {MovePane = "down";})
              (bind "Ctrl Shift k" {MovePane = "up";})
              (bind "Ctrl Shift l" {MovePane = "right";})
              (bind "Ctrl Alt o" {PreviousSwapLayout = {};})
              (bind "Ctrl Alt i" {NextSwapLayout = {};})
              (bind "Ctrl Alt q" {CloseFocus = {};})

              (bind "Ctrl Alt t" {NewTab = {};})
              (bind "Ctrl Alt u" {GoToPreviousTab = {};})
              (bind "Ctrl Alt d" {GoToNextTab = {};})
              (bind "Ctrl Shift u" {MoveTab = "left";})
              (bind "Ctrl Shift d" {MoveTab = "right";})

              (bind "Ctrl Alt m" {ToggleGroupMarking = {};})
              (bind "Ctrl Alt e" {TogglePaneInGroup = {};})

              (bind "Ctrl Alt w" {
                Run = {
                  _args = [(lib.getExe pkgs.zellij-sessionizer)];
                  floating = true;
                  close_on_exit = true;
                  width = 0;
                  height = 0;
                  borderless = true;
                };
              })
              (bind "Ctrl Alt z" {
                LaunchOrFocusPlugin = {
                  _args = ["session-manager"];
                  floating = true;
                  move_to_focused_tab = true;
                };
              })
              (bind "Ctrl Alt x" {
                LaunchOrFocusPlugin = {
                  _args = ["zellij:layout-manager"];
                  floating = true;
                  move_to_focused_tab = true;
                };
              })

              (bind "Ctrl Shift d" {Detach = {};})
              (bind "Ctrl Shift q" {Quit = {};})
            ])
            (mode "locked" [(bindNormal "Ctrl Shift g" {})])

            (shared_except ["normal" "locked"] [(bindNormal "esc" {})])

            (shared_except ["resize" "locked"] [(bind "Ctrl Shift r" {SwitchToMode = "resize";})])
            (mode "resize" [
              (bindNormal "Ctrl Shift r" {})
              (bind "+" {Resize = "increase";})
              (bind "-" {Resize = "decrease";})
              (bind "h" {Resize = "increase left";})
              (bind "j" {Resize = "increase down";})
              (bind "k" {Resize = "increase up";})
              (bind "l" {Resize = "increase right";})
              (bind "H" {Resize = "decrease left";})
              (bind "J" {Resize = "decrease down";})
              (bind "K" {Resize = "decrease up";})
              (bind "L" {Resize = "decrease right";})
            ])

            (shared_except ["pane" "locked"] [(bind "Ctrl Shift p" {SwitchToMode = "pane";})])
            (mode "pane" [
              (bindNormal "Ctrl Shift p" {})
              (bind "r" {
                SwitchToMode = "renamepane";
                PaneNameInput = 0;
              })
              (bindNormal "f" {ToggleFocusFullscreen = {};})
              (bindNormal "t" {TogglePaneEmbedOrFloating = {};})
              (bindNormal "p" {TogglePanePinned = {};})
              (bindNormal "z" {TogglePaneFrames = {};})
            ])
            (mode "renamepane" [
              (bind "esc" {
                UndoRenamePane = {};
                SwitchToMode = "pane";
              })
              (bindNormal "enter" {})
            ])

            (shared_except ["tab" "locked"] [(bind "Ctrl Shift t" {SwitchToMode = "tab";})])
            (mode "tab" [
              (bindNormal "Ctrl Shift t" {})
              (bindNormal "1" {GoToTab = 1;})
              (bindNormal "2" {GoToTab = 2;})
              (bindNormal "3" {GoToTab = 3;})
              (bindNormal "4" {GoToTab = 4;})
              (bindNormal "5" {GoToTab = 5;})
              (bindNormal "6" {GoToTab = 6;})
              (bindNormal "7" {GoToTab = 7;})
              (bindNormal "8" {GoToTab = 8;})
              (bindNormal "9" {GoToTab = 9;})
              (bind "r" {
                SwitchToMode = "renametab";
                TabNameInput = 0;
              })
              (bindNormal "s" {ToggleActiveSyncTab = {};})
              (bindNormal "b" {BreakPane = {};})
              (bindNormal "h" {BreakPaneLeft = {};})
              (bindNormal "l" {BreakPaneRight = {};})
              (bindNormal "q" {CloseTab = {};})
            ])
            (mode "renametab" [
              (bind "esc" {
                UndoRenameTab = {};
                SwitchToMode = "tab";
              })
              (bindNormal "enter" {})
            ])

            (shared_except ["scroll" "locked"] [(bind "Ctrl Shift e" {SwitchToMode = "scroll";})])
            (mode "scroll" [
              (bindNormal "Ctrl Shift e" {})
              (bind "j" {ScrollDown = {};})
              (bind "k" {ScrollUp = {};})
              (bind "d" {HalfPageScrollDown = {};})
              (bind "u" {HalfPageScrollUp = {};})
              (bindNormal "t" {ScrollToTop = {};})
              (bindNormal "b" {ScrollToBottom = {};})
              (bindNormal "e" {EditScrollback = {};})
              (bind "/" {
                SwitchToMode = "entersearch";
                SearchInput = 0;
              })
              (bind "n" {Search = "down";})
              (bind "N" {Search = "up";})
              (bind "c" {SearchToggleOption = "CaseSensitivity";})
              (bind "w" {SearchToggleOption = "Wrap";})
              (bind "o" {SearchToggleOption = "WholeWord";})
            ])
            (mode "entersearch" [
              (bind "esc" {
                SwitchToMode = "scroll";
                SearchInput = 0;
              })
              (bind "enter" {SwitchToMode = "scroll";})
            ])
          ];
        };

        layout.layout._children = let
          default_tab_template = children: {default_tab_template._children = children;};

          swap_tiled_layout = name: children: {
            swap_tiled_layout._props.name = name;
            swap_tiled_layout._children = children;
          };
          tab = props: children: {tab = {_props = props;} // (pane {split_direction = "vertical";} children);};
          pane = props: children: {
            pane._props = props;
            pane._children = children;
          };

          swap_floating_layout = name: children: {
            swap_floating_layout._props.name = name;
            swap_floating_layout._children = children;
          };
          floating_panes = props: children: {
            floating_panes._props = props;
            floating_panes._children = children;
          };
          floating_pane = x: y: width: height: {pane = {inherit x y width height;};};

          children = {children = {};};
        in [
          (default_tab_template [
            {
              pane._props = {
                size = 1;
                borderless = true;
              };

              pane.plugin = {
                _props.location = "zjstatus";

                color_bg = "#343f44";
                color_short_fg = "#2d353b";
                color_short_bg = "#9da9a0";
                color_label_fg = "#9da9a0";
                color_label_bg = "#475258";

                format_left = "{mode}#[fg=#9da9a0,bg=$bg,bold] {session}";
                format_center = "{tabs}";
                format_right = "{swap_layout}";
                format_space = "#[bg=$bg]";
                format_hide_on_overlength = "true";
                format_precedence = "lcr";

                mode_normal = "#[fg=#2d353b,bg=#a7c080,bold] NORMAL ";
                mode_locked = "#[fg=#2d353b,bg=#d3c6aa,bold] LOCKED ";
                mode_resize = "#[fg=#2d353b,bg=#a7c080,bold] NORMAL #[bg=$bg] #[fg=$short_fg,bg=$short_bg,bold] +/- #[fg=$label_fg,bg=$label_bg] Resize #[fg=$short_fg,bg=$short_bg,bold] h/j/k/l #[fg=$label_fg,bg=$label_bg] Increase #[fg=$short_fg,bg=$short_bg,bold] H/J/K/L #[fg=$label_fg,bg=$label_bg] Decrease ";
                mode_pane = "#[fg=#2d353b,bg=#a7c080,bold] NORMAL #[bg=$bg] #[fg=$short_fg,bg=$short_bg,bold] r #[fg=$label_fg,bg=$label_bg] Rename #[fg=$short_fg,bg=$short_bg,bold] f #[fg=$label_fg,bg=$label_bg] Fullscreen #[fg=$short_fg,bg=$short_bg,bold] t #[fg=$label_fg,bg=$label_bg] Float #[fg=$short_fg,bg=$short_bg,bold] p #[fg=$label_fg,bg=$label_bg] Pin #[fg=$short_fg,bg=$short_bg,bold] z #[fg=$label_fg,bg=$label_bg] Frames ";
                mode_rename_pane = "#[fg=#2d353b,bg=#a7c080,bold] NORMAL #[bg=$bg] #[fg=$label_fg,bg=$label_bg] Type... ";
                mode_tab = "#[fg=#2d353b,bg=#a7c080,bold] NORMAL #[bg=$bg] #[fg=$short_fg,bg=$short_bg,bold] 1-9 #[fg=$label_fg,bg=$label_bg] Jump #[fg=$short_fg,bg=$short_bg,bold] r #[fg=$label_fg,bg=$label_bg] Rename #[fg=$short_fg,bg=$short_bg,bold] s #[fg=$label_fg,bg=$label_bg] Sync #[fg=$short_fg,bg=$short_bg,bold] b #[fg=$label_fg,bg=$label_bg] Break #[fg=$short_fg,bg=$short_bg,bold] h/l #[fg=$label_fg,bg=$label_bg] Move pane #[fg=$short_fg,bg=$short_bg,bold] q #[fg=$label_fg,bg=$label_bg] Close ";
                mode_rename_tab = "#[fg=#2d353b,bg=#a7c080,bold] NORMAL #[bg=$bg] #[fg=$label_fg,bg=$label_bg] Type... ";
                mode_scroll = "#[fg=#2d353b,bg=#7fbbb3,bold] SCROLL #[bg=$bg] #[fg=$short_fg,bg=$short_bg,bold] j/k/d/u/t/b #[fg=$label_fg,bg=$label_bg] Scroll #[fg=$short_fg,bg=$short_bg,bold] e #[fg=$label_fg,bg=$label_bg] Edit #[fg=$short_fg,bg=$short_bg,bold] / #[fg=$label_fg,bg=$label_bg] Search #[fg=$short_fg,bg=$short_bg,bold] n/N #[fg=$label_fg,bg=$label_bg] Cycle #[fg=$short_fg,bg=$short_bg,bold] c/w/o #[fg=$label_fg,bg=$label_bg] Options ";
                mode_enter_search = "#[fg=#2d353b,bg=#7fbbb3,bold] SCROLL #[bg=$bg] #[fg=$label_fg,bg=$label_bg] Type... ";

                tab_normal = "#[fg=#9da9a0,bg=#475258] {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}";
                tab_active = "#[fg=#2d353b,bg=#a7c080,bold] {name} {fullscreen_indicator}{sync_indicator}{floating_indicator}";
                tab_fullscreen_indicator = "󰊓 ";
                tab_sync_indicator = " ";
                tab_floating_indicator = "󰉈 ";

                swap_layout_format = "#[fg=#9da9a0,bg=#475258] {name} ";
                swap_layout_hide_if_empty = "true";
              };
            }

            children
          ])

          (swap_tiled_layout "" [
            (tab {max_panes = 6;} [
              (pane {} [])
              (pane {} [children])
            ])
            (tab {max_panes = 10;} [
              (pane {} [])
              (pane {} [(pane {} []) (pane {} []) (pane {} []) (pane {} [])])
              (pane {} [children])
            ])
          ])

          (swap_tiled_layout "stacked" [
            (tab {min_panes = 4;} [
              (pane {} [])
              (pane {stacked = true;} [children])
            ])
          ])

          (swap_floating_layout "" [
            (floating_panes {exact_panes = 1;} [
              (floating_pane "4%" "7%" "92%" "90%")
            ])
            (floating_panes {exact_panes = 2;} [
              (floating_pane "4%" "7%" "46%" "90%")
              (floating_pane "50%" "7%" "46%" "90%")
            ])
            (floating_panes {exact_panes = 3;} [
              (floating_pane "4%" "7%" "46%" "90%")
              (floating_pane "50%" "7%" "46%" "46%")
              (floating_pane "50%" "53%" "46%" "45%")
            ])
            (floating_panes {exact_panes = 4;} [
              (floating_pane "4%" "7%" "46%" "46%")
              (floating_pane "50%" "7%" "46%" "46%")
              (floating_pane "4%" "53%" "46%" "45%")
              (floating_pane "50%" "53%" "46%" "45%")
            ])
          ])

          (swap_floating_layout "stacked" [
            (floating_panes {exact_panes = 1;} [
              (floating_pane "4%" "7%" "92%" "90%")
            ])
            (floating_panes {exact_panes = 2;} [
              (floating_pane "4%" "6%" "92%" "90%")
              (floating_pane "4%" "7%" "92%" "90%")
            ])
            (floating_panes {exact_panes = 3;} [
              (floating_pane "4%" "6%" "92%" "90%")
              (floating_pane "4%" "7%" "92%" "90%")
              (floating_pane "4%" "9%" "92%" "90%")
            ])
            (floating_panes {exact_panes = 4;} [
              (floating_pane "4%" "4%" "92%" "90%")
              (floating_pane "4%" "6%" "92%" "90%")
              (floating_pane "4%" "7%" "92%" "90%")
              (floating_pane "4%" "9%" "92%" "90%")
            ])
            (floating_panes {exact_panes = 5;} [
              (floating_pane "4%" "4%" "92%" "90%")
              (floating_pane "4%" "6%" "92%" "90%")
              (floating_pane "4%" "7%" "92%" "90%")
              (floating_pane "4%" "9%" "92%" "90%")
              (floating_pane "4%" "11%" "92%" "90%")
            ])
            (floating_panes {exact_panes = 6;} [
              (floating_pane "4%" "2%" "92%" "90%")
              (floating_pane "4%" "4%" "92%" "90%")
              (floating_pane "4%" "6%" "92%" "90%")
              (floating_pane "4%" "7%" "92%" "90%")
              (floating_pane "4%" "9%" "92%" "90%")
              (floating_pane "4%" "11%" "92%" "90%")
            ])
          ])
        ];
      };
    };
  };
}
