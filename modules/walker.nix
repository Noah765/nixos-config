{
  lib,
  inputs,
  pkgs,
  config,
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
    os.nix.settings = {
      substituters = [ "https://walker.cachix.org" ];
      trusted-public-keys = [ "walker.cachix.org-1:fG8q+uAaMqhsMxWjwvk0IMb4mFPFLqHjuvfwQxE4oJM=" ];
    };

    hm = {
      programs.walker = {
        enable = true;
        runAsService = true;

        # TODO Clipboard module
        config = {
          align.width = 400;
          placeholder = "Search...";
          enable_typeahead = true;
          list = {
            height = 300;
            margin_top = 10;
          };
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

        style = ''
          #box {
            padding: 10px;
            border-radius: 2px;
          }

          #search {
            border-radius: 0;
            outline: none;
            outline-width: 0px;
            box-shadow: none;
            border-bottom: none;
            border: none;
            background: none;
            padding-left: 10px;
            padding-right: 10px;
            padding-top: 0px;
            padding-bottom: 0px;
            border-radius: 2px;
          }

          #typeahead {
            border-radius: 0;
            outline: none;
            outline-width: 0px;
            box-shadow: none;
            border-bottom: none;
            border: none;
            background: none;
            padding-left: 10px;
            padding-right: 10px;
            padding-top: 0px;
            padding-bottom: 0px;
            border-radius: 2px;
          }

          #spinner {
            opacity: 0;
          }
          #spinner.visible {
            opacity: 1;
          }

          #typeahead {
            background: none;
            opacity: 0.5;
          }

          #search placeholder {
            opacity: 0.5;
          }

          row:selected {
            background: #1f1f28;
          }

          .item {
            padding: 5px;
            border-radius: 2px;
          }

          .icon {
            padding-right: 5px;
          }

          .sub {
            opacity: 0.5;
          }

          .activationlabel {
            opacity: 0.25;
          }

          .activation .activationlabel {
            opacity: 1;
            color: #76946a;
          }

          .activation .textwrapper,
          .activation .icon,
          .activation .search {
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
