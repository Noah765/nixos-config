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
  inputs.walker.url = "github:abenz1267/walker/512b728c4282edd810ba0aee2d438f2f2c5197ee";

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

    hm = {
      programs.walker = {
        enable = true;
        runAsService = true;

        # TODO Clipboard module
        # TODO Enable the application module cache?
        config = {
          ui.fullscreen = true;
          list.show_sub_single_module = true;

          activation_mode.use_alt = true;

          plugins = [
            {
              name = "calculator";
              src = let
                script = pkgs.writeShellScriptBin "walker-calculator-plugin" ''
                  prompt=$(cat)

                  mkdir -p ~/.cache/walker
                  touch ~/.cache/walker/calculator-history.txt

                  echo "$prompt" > /tmp/walker-calculator-input
                  result=$(cat /tmp/walker-calculator-output)

                  escape_json() { echo "$1" | sed 's/"/\\"/g'; }
                  escape_json_bash() { escape_json "$(echo "$1" | sed "s/'/'\\\\\\\\'''/g")"; }

                  output=()
                  add_item() {
                    output+=("$(cat << END
                      {
                        "label": "$(escape_json "$2")",
                        "sub": "$(escape_json "$1")",
                        "score_final": $3,
                        "exec": "${getExe execScript} '$(escape_json_bash "$1")' '$(escape_json_bash "$2")'"
                      }
                  END
                    )")
                  }

                  add_item "$prompt" "$result" 31

                  counter=0
                  while read prompt; read result; do
                    ((counter++))
                    add_item "$prompt" "$result" $counter
                  done < ~/.cache/walker/calculator-history.txt

                  IFS=,
                  echo "[''${output[*]}]"
                '';
                execScript = pkgs.writeShellScriptBin "walker-calculator-plugin-exec" ''
                  echo "$1" >> ~/.cache/walker/calculator-history.txt
                  echo "$2" >> ~/.cache/walker/calculator-history.txt
                  tail -n 30 ~/.cache/walker/calculator-history.txt > /tmp/walker-calculator-history
                  mv /tmp/walker-calculator-history ~/.cache/walker/calculator-history.txt

                  walker -m calculator
                '';
              in
                getExe script;
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

      systemd.user.services.walker-calculator = let
        inputFifo = "/tmp/walker-calculator-input";
        outputFifo = "/tmp/walker-calculator-output";

        script = pkgs.writeScriptBin "walker-calculator" ''
          #!${getExe pkgs.expect}

          proc validate_input {input} {
            set group_symbols {| ( ) [ ] \{ \} ⌈ ⌉ ⌊ ⌋}

            set stack {}

            foreach x [split $input ""] {
              set index [lsearch -exact $group_symbols $x]
              if {$index == -1} { continue }

              set last [lindex $stack end]

              if {$index % 2 == 1 || $x == "|" && $last != "|"} {
                lappend stack $x
                continue
              }

              set stack [lrange $stack 0 end-1]

              if {[lsearch -exact $group_symbols $last] + 1 == $index || $x == "|"} { continue }

              if {$last == ""} { return "'$x' is unpaired." }
              return "'$last' is not properly closed."
            }

            set last [lindex $stack end]
            if {$last != ""} { return "'$last' is not properly closed." }
          }

          exec rm -f ${inputFifo} ${outputFifo}
          exec mkfifo ${inputFifo}
          exec mkfifo ${outputFifo}

          spawn ${getExe pkgs.kalker}
          expect >>

          while true {
            set input [exec cat ${inputFifo}]

            set validation_result [validate_input $input]
            if {$validation_result != ""} {
              exec echo $validation_result > ${outputFifo}
              continue
            }

            send $input\n
            expect \n
            expect {
              -re "(.*)\r\n" { set output $expect_out(1,string) }
              >>             { set output "" }
            }

            exec echo $output > ${outputFifo}
          }
        '';
      in {
        Unit.Description = "Calculator plugin for walker";
        Install.WantedBy = ["walker.service"];
        Service = {
          ExecStart = getExe script;
          ExecStopPost = "${getExe' pkgs.coreutils "rm"} -f ${inputFifo} ${outputFifo} /tmp/walker-calculator-history";
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
