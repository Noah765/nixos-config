{
  lib,
  inputs,
  pkgs,
  config,
  osConfig,
  ...
}:
with lib;
let
  cfg = config.walker;
in
{
  inputs.walker.url = "github:abenz1267/walker";

  hmImports = [ inputs.walker.homeManagerModules.default ];

  options.walker.enable = mkEnableOption "walker";

  config = mkIf cfg.enable {
    assertions = [
      {
        assertion = config.stylix.enable;
        message = "The walker module is dependent on the stylix module.";
      }
    ];

    os.nix.settings = {
      substituters = [ "https://walker.cachix.org" ];
      trusted-public-keys = [ "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" ];
    };

    hm = {
      programs.walker = {
        enable = true;
        runAsService = true;

        # TODO Clipboard module
        # TODO Enable the application module cache?
        config = {
          align.anchors.top = true;
          placeholder = "Search...";
          enable_typeahead = true;
          show_initial_entries = true;
          icons.size = 28;
          activation_mode.use_alt = true;
          modules = [
            { name = "applications"; }
            {
              name = "websearch";
              prefix = "?";
            }
            {
              name = "commands";
              prefix = ":";
            }
          ];
          external = [
            {
              name = "calculator";
              src =
                let
                  script = pkgs.writeShellScriptBin "walker-calculator" ''
                    touch ~/.cache/walker/calculator-history.txt

                    echo "$1" > /tmp/walker-calculator-input
                    result=$(cat /tmp/walker-calculator-output)

                    cat << END
                      [{
                        "label": "$result",
                        "sub": "$1",
                        "score_final": 31,
                        "exec": "${execScript}/bin/walker-calculator-exec '$1' '$result'"
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
                  execScript = pkgs.writeShellScriptBin "walker-calculator-exec" ''
                    echo "$1" >> ~/.cache/walker/calculator-history.txt
                    echo "$2" >> ~/.cache/walker/calculator-history.txt
                    tail -n 30 ~/.cache/walker/calculator-history.txt > /tmp/walker-calculator-history
                    mv /tmp/walker-calculator-history ~/.cache/walker/calculator-history.txt

                    walker -m calculator
                  '';
                in
                "${script}/bin/walker-calculator '%TERM%'";
            }
          ];
        };

        style = with osConfig.lib.stylix.colors; ''
          #window {
            min-width: 380px;
            background: 0;
          }

          #box {
            margin-top: 16px;
            padding: 8px;
            background: #${base00};
            border: 1px solid #${base0D};
            border-radius: 12px;
          }

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

          scrolledwindow {
            min-height: 280px;
            margin-top: 20px;
          }

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

      systemd.user.services.walker-calculator =
        let
          script = pkgs.writeShellScriptBin "walker-calculator" ''
            mkfifo /tmp/walker-calculator-input
            mkfifo /tmp/walker-calculator-output

            ${pkgs.expect}/bin/expect -c '
              spawn ${pkgs.kalker}/bin/kalker
              expect >>
              while true {
                set input [exec cat /tmp/walker-calculator-input]
                send $input\n
                expect \n
                expect {
                  -re "(.*)\r\n"   { set output $expect_out(1,string) }
                  >>               { set output "" }
                }
                exec sh -c "echo \"$output\" > /tmp/walker-calculator-output"
              }'
          '';
        in
        {
          Unit.Description = "Calculator plugin for walker";
          Install.WantedBy = [ "walker.service" ];
          Service = {
            ExecStart = "${script}/bin/walker-calculator";
            ExecStopPost = "rm /tmp/walker-calculator-input /tmp/walker-calculator-output /tmp/walker-calculator-history";
          };
        };
    };
  };
}
