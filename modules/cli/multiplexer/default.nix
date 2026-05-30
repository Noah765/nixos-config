{
  lib,
  wlib,
  inputs,
  ...
}: let
  sessionizer = pkgs:
    lib.getExe (wlib.wrapPackage {
      inherit pkgs;

      package = inputs.zellij-sessionizer;
      exePath = "zellij-sessionizer";
      binName = "zellij-sessionizer";

      runtimePkgs = [pkgs.fzf];

      env = {
        ZELLIJ_SESSIONIZER_SEARCH_PATHS.data = "$HOME/projects";
        ZELLIJ_SESSIONIZER_SEARCH_PATHS.esc-fn = x: "\"${x}\"";
        ZELLIJ_SESSIONIZER_SPECIFIC_PATHS = "/etc/nixos";
        ZELLIJ_SESSIONIZER_SWITCH_PLUGIN = "file:${lib.getExe' inputs.zellij-switch.packages.${pkgs.stdenv.system}.default "zellij-switch.wasm"}";
      };
    });

  zjstatus = pkgs: lib.getExe' inputs.zjstatus.packages.${pkgs.stdenv.system}.default "zjstatus.wasm";
in {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.multiplexer.enable = lib.mkEnableOption "Zellij";

    config = lib.mkIf config.cli.multiplexer.enable {
      wrappers.multiplexer.enable = true;

      cli.nushell.shellAliases.z = "zellij";
      cli.nushell.keybindings = lib.singleton {
        name = "zellij_sessionizer";
        modifier = "control";
        keycode = "char_s";
        mode = ["vi_normal" "vi_insert"];
        event.send = "executehostcommand";
        event.cmd = sessionizer pkgs;
      };

      hm.home.file.".cache/zellij/permissions.kdl".text = "\"${zjstatus pkgs}\" { ReadApplicationState; ChangeApplicationState; RunCommands; }";

      core.impermanence.hm.directories = [".cache/zellij/contract_version_1/session_info"];
    };
  };

  flake.wrappers.multiplexer = {
    pkgs,
    config,
    ...
  }: {
    imports = [wlib.modules.default];

    package = pkgs.zellij;

    flags."--config" = config.constructFiles.config.path;

    constructFiles.config.relPath = "${config.binName}-config.kdl";
    constructFiles.config.content = ''
      pane_frames false
      theme "everforest-dark"
      copy_on_select false
      layout_dir "${./layouts}"
      show_startup_tips false
      show_release_notes false
      mouse_hover_effects false

      ui { pane_frames { rounded_corners true; }; }

      plugins { zjstatus location="file:${zjstatus pkgs}"; }

      keybinds clear-defaults=true {
        shared_except "locked" {
          bind "Ctrl Shift g" { SwitchToMode "locked"; }

          bind "Ctrl Alt c" { Copy; }

          bind "Ctrl Alt f" { ToggleFloatingPanes; }

          bind "Ctrl Alt n" { NewPane; }
          bind "Ctrl Alt s" { NewPane "down"; }
          bind "Ctrl Alt v" { NewPane "right"; }
          bind "Ctrl Alt a" { NewPane "stacked"; }
          bind "Ctrl Alt h" { MoveFocusOrTab "left"; }
          bind "Ctrl Alt j" { MoveFocus "down"; }
          bind "Ctrl Alt k" { MoveFocus "up"; }
          bind "Ctrl Alt l" { MoveFocusOrTab "right"; }
          bind "Ctrl Shift h" { MovePane "left"; }
          bind "Ctrl Shift j" { MovePane "down"; }
          bind "Ctrl Shift k" { MovePane "up"; }
          bind "Ctrl Shift l" { MovePane "right"; }
          bind "Ctrl Alt o" { PreviousSwapLayout; }
          bind "Ctrl Alt i" { NextSwapLayout; }
          bind "Ctrl Alt q" { CloseFocus; }

          bind "Ctrl Alt t" { NewTab; }
          bind "Ctrl Alt u" { GoToPreviousTab; }
          bind "Ctrl Alt d" { GoToNextTab; }
          bind "Ctrl Shift u" { MoveTab "left"; }
          bind "Ctrl Shift d" { MoveTab "right"; }

          bind "Ctrl Alt m" { ToggleGroupMarking; }
          bind "Ctrl Alt e" { TogglePaneInGroup; }

          bind "Ctrl Alt w" {
            Run "${sessionizer pkgs}" {
              floating true
              name "Sessionizer"
              close_on_exit true
              width "50%"
              height "80%"
            }
          }
          bind "Ctrl Alt z" {
            LaunchOrFocusPlugin "session-manager" {
              floating true
              move_to_focused_tab true
            }
          }
          bind "Ctrl Alt x" {
            LaunchOrFocusPlugin "zellij:layout-manager" {
              floating true
              move_to_focused_tab true
            }
          }

          bind "Ctrl Shift d" { Detach; }
          bind "Ctrl Shift q" { Quit; }
        }
        locked {
          bind "Ctrl Shift g" { SwitchToMode "normal"; }
        }
        shared_except "locked" "normal" {
          bind "esc" { SwitchToMode "normal"; }
        }
        shared_except "resize" "locked" {
          bind "Ctrl Shift r" { SwitchToMode "resize"; }
        }
        resize {
          bind "Ctrl Shift r" { SwitchToMode "normal"; }
          bind "+" { Resize "increase"; }
          bind "-" { Resize "decrease"; }
          bind "h" { Resize "increase left"; }
          bind "j" { Resize "increase down"; }
          bind "k" { Resize "increase up"; }
          bind "l" { Resize "increase right"; }
          bind "H" { Resize "decrease left"; }
          bind "J" { Resize "decrease down"; }
          bind "K" { Resize "decrease up"; }
          bind "L" { Resize "decrease right"; }
        }
        shared_except "pane" "locked" {
          bind "Ctrl Shift p" { SwitchToMode "pane"; }
        }
        pane {
          bind "Ctrl Shift p" { SwitchToMode "normal"; }
          bind "r" { SwitchToMode "renamepane"; PaneNameInput 0; }
          bind "f" { ToggleFocusFullscreen; SwitchToMode "normal"; }
          bind "t" { TogglePaneEmbedOrFloating; SwitchToMode "normal"; }
          bind "p" { TogglePanePinned; SwitchToMode "normal"; }
          bind "z" { TogglePaneFrames; SwitchToMode "Normal"; }
        }
        renamepane {
          bind "esc" { UndoRenamePane; SwitchToMode "pane"; }
          bind "enter" { SwitchToMode "normal"; }
        }
        shared_except "tab" "locked" {
          bind "Ctrl Shift t" { SwitchToMode "tab"; }
        }
        tab {
          bind "Ctrl Shift t" { SwitchToMode "normal"; }
          bind "1" { GoToTab 1; SwitchToMode "normal"; }
          bind "2" { GoToTab 2; SwitchToMode "normal"; }
          bind "3" { GoToTab 3; SwitchToMode "normal"; }
          bind "4" { GoToTab 4; SwitchToMode "normal"; }
          bind "5" { GoToTab 5; SwitchToMode "normal"; }
          bind "6" { GoToTab 6; SwitchToMode "normal"; }
          bind "7" { GoToTab 7; SwitchToMode "normal"; }
          bind "8" { GoToTab 8; SwitchToMode "normal"; }
          bind "9" { GoToTab 9; SwitchToMode "normal"; }
          bind "r" { SwitchToMode "renametab"; TabNameInput 0; }
          bind "s" { ToggleActiveSyncTab; SwitchToMode "normal"; }
          bind "b" { BreakPane; SwitchToMode "normal"; }
          bind "h" { BreakPaneLeft; SwitchToMode "normal"; }
          bind "l" { BreakPaneRight; SwitchToMode "normal"; }
          bind "q" { CloseTab; SwitchToMode "normal"; }
        }
        renametab {
          bind "esc" { UndoRenameTab; SwitchToMode "tab"; }
          bind "enter" { SwitchToMode "normal"; }
        }
        shared_except "scroll" "locked" {
          bind "Ctrl Shift e" { SwitchToMode "scroll"; }
        }
        scroll {
          bind "Ctrl Shift e" { SwitchToMode "normal"; }
          bind "j" { ScrollDown; }
          bind "k" { ScrollUp; }
          bind "d" { HalfPageScrollDown; }
          bind "u" { HalfPageScrollUp; }
          bind "t" { ScrollToTop; SwitchToMode "normal"; }
          bind "b" { ScrollToBottom; SwitchToMode "normal"; }
          bind "e" { EditScrollback; SwitchToMode "normal"; }
          bind "/" { SwitchToMode "entersearch"; SearchInput 0; }
          bind "n" { Search "down"; }
          bind "N" { Search "up"; }
          bind "c" { SearchToggleOption "CaseSensitivity"; }
          bind "w" { SearchToggleOption "Wrap"; }
          bind "o" { SearchToggleOption "WholeWord"; }
        }
        entersearch {
          bind "esc" { SwitchToMode "scroll"; SearchInput 0; }
          bind "enter" { SwitchToMode "scroll"; }
        }
      }
    '';
  };
}
