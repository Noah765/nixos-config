{
  lib,
  inputs,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib; let
  cfg = config.desktop.walker;
in {
  inputs.walker.url = "github:abenz1267/walker";

  hmImports = [inputs.walker.homeManagerModules.default];

  options.desktop.walker.enable = mkEnableOption "Walker";

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.desktop.hyprland.enable;
        message = "The walker module is dependent on the hyprland module.";
      }
      {
        assertion = config.desktop.stylix.enable;
        message = "The walker module is dependent on the stylix module.";
      }
    ];

    os.nix.settings = {
      substituters = ["https://walker.cachix.org"];
      trusted-public-keys = ["walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM="];
    };

    hm = {
      programs.walker = {
        enable = true;
        runAsService = true;

        # TODO Clipboard module
        # TODO Enable the application module cache?
        config = {
          ui.fullscreen = true;

          activation_mode.use_alt = true;

          disabled = ["clipboard" "custom_commands" "emojis" "finder" "hyprland" "runner" "ssh" "switcher" "dmenu"];
          builtins = {
            applications.typeahead = true;
            commands = {
              prefix = ":";
              switcher_only = false;
            };
            websearch.prefix = "?";
          };

          plugins = [
            {
              name = "calculator";
              src = let
                script = pkgs.writeShellScriptBin "walker-calculator-plugin" ''
                  touch ~/.cache/walker/calculator-history.txt

                  echo "$1" > /tmp/walker-calculator-input
                  result=$(cat /tmp/walker-calculator-output)

                  cat << END
                    [{
                      "label": "$result",
                      "sub": "$1",
                      "score_final": 31,
                      "exec": "${execScript}/bin/walker-calculator-plugin-exec '$1' '$result'"
                    }
                  END

                  counter=0
                  while read prompt; read result; do
                    ((counter++))

                    # No other characters are allowed before or after the heredoc delimiter
                    cat << END
                      , {
                        "label": "$result",
                        "sub": "$prompt",
                        "score_final": $counter
                      }
                  END
                  done < ~/.cache/walker/calculator-history.txt

                  echo "]"
                '';
                execScript = pkgs.writeShellScriptBin "walker-calculator-plugin-exec" ''
                  echo "$1" >> ~/.cache/walker/calculator-history.txt
                  echo "$2" >> ~/.cache/walker/calculator-history.txt
                  tail -n 30 ~/.cache/walker/calculator-history.txt > /tmp/walker-calculator-history
                  mv /tmp/walker-calculator-history ~/.cache/walker/calculator-history.txt

                  walker -m calculator
                '';
              in "${script}/bin/walker-calculator-plugin '%TERM%'";
            }
          ];
        };

        style = with osConfig.lib.stylix.colors; ''
          #window { background: 0; }

          #box {
            min-width: 380px;
            min-height: 332px;
            padding: 8px;
            background: #${base00};
            border: 1px solid #${base0D};
            border-radius: 12px;
          }

          /* TODO Verify the following CSS once https://github.com/abenz1267/walker/issues/84 is fixed
          #searchwrapper { margin-right: -16px; }

          entry {
            min-height: 32px;
            padding: 0 12px 0 12px;
            border-radius: 8px;
          }
          entry > image:first-child {
            opacity: 1;
            margin-right: 2px;
          }
          entry placeholder { opacity: 0.5; }
          entry > image:last-child {
            opacity: 0;
            margin-left: 2px;
          }

          #search {
            background: 0;
            outline: 0;
          }
          #typeahead {
            background: #${base01};
            color: #${base05}88;
          }

          @keyframes spin { to { -gtk-icon-transform: rotate(1turn); } }
          #spinner { opacity: 0; }
          #spinner.visible {
            opacity: 1;
            transform: translateX(-28px);
            animation: spin 1s linear infinite;
          }
          */

          #scroll { margin-top: 20px; }

          row {
            padding: 4px 8px 4px 8px;
            outline: 0;
          }
          row:hover { background: 0; }
          row:selected {
            background: #${base02};
            border-radius: 8px;
          }

          .icon { padding-right: 12px;}

          .sub { opacity: 0.5; }

          .activationlabel { opacity: 0.25; }

          .activation .activationlabel {
            opacity: 1;
            color: #${base0D};
          }

          .activation #searchwrapper,
          .activation .icon,
          .activation .textwrapper {
            opacity: 0.5;
          }
        '';
      };

      # TODO memory leaks?
      systemd.user.services.walker-calculator = let
        script = pkgs.writeShellScriptBin "walker-calculator" ''
          mkfifo /tmp/walker-calculator-input
          mkfifo /tmp/walker-calculator-output

          ${pkgs.expect}/bin/expect -c '
            set group_symbols {( ) [ ] \{ \} ⌈ ⌉ ⌊ ⌋ | |}

            spawn ${pkgs.kalker}/bin/kalker
            expect >>

            while true {
              set input [exec cat /tmp/walker-calculator-input]

              foreach {open close} $group_symbols {
                set open_count [regexp -all \\$open $input]
                set close_count [regexp -all \\$close $input]

                if {$open_count != $close_count} {
                  puts "Not balanced"
                  exit
                }
              }

              send $input\n
              expect \n
              expect {
                -re "(.*)\r\n"   { set output $expect_out(1,string) }
                >>               { set output "" }
              }
              exec sh -c "echo \"$output\" > /tmp/walker-calculator-output"
            }'
        '';
      in {
        Unit.Description = "Calculator plugin for walker";
        Install.WantedBy = ["walker.service"];
        Service = {
          ExecStart = "${script}/bin/walker-calculator";
          ExecStopPost = "rm /tmp/walker-calculator-input /tmp/walker-calculator-output /tmp/walker-calculator-history";
        };
      };
    };

    desktop.hyprland.settings = {
      layerrule = [
        "noanim, walker"
        "blur, walker"
        "dimaround, walker"
      ];

      bindr = ["Super, Super_L, exec, walker"];
    };
  };
}
