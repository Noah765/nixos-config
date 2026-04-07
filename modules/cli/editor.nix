{
  lib,
  moduleWithSystem,
  inputs,
  ...
}: {
  perSystem = {pkgs, ...}: {
    packages.editor =
      (inputs.wrappers.wrapperModules.helix.apply {
        inherit pkgs;

        settings = {
          theme = "everforest_dark";
          editor = {
            scrolloff = 9;
            shell = [(lib.getExe pkgs.nushell) "-c"];
            line-number = "relative";
            completion-timeout = 5;
            completion-trigger-len = 1;
            completion-replace = true;
            color-modes = true;
            trim-final-newlines = true;
            trim-trailing-whitespace = true;
            end-of-line-diagnostics = "hint";
            statusline.left = ["mode" "file-name" "read-only-indicator" "file-modification-indicator" "spacer" "spinner"];
            statusline.mode = {
              normal = "NORMAL";
              insert = "INSERT";
              select = "SELECT";
            };
            lsp.display-inlay-hints = true;
            cursor-shape.insert = "bar";
            auto-save.focus-lost = true;
            soft-wrap.enable = true;
            inline-diagnostics.cursor-line = "warning";
          };
          keys.normal."C-p" = '':lsp-workspace-command tinymist.pinMain "%sh{'%{buffer_name}' | path expand}"'';
          keys.normal.space.o = ['':lsp-workspace-command tinymist.doStartBrowsingPreview ["--invert-colors=auto"]'' ":! qutebrowser --target window --loglevel warning http://127.0.0.1:23625"];
        };

        languages.language = lib.mapAttrsToList (name: value: {inherit name;} // value) (lib.recursiveUpdate
          (lib.genAttrs (lib.map (x: x.name) (lib.importTOML "${pkgs.helix-unwrapped.src}/languages.toml").language) (_: {
            formatter.command = "treefmt";
            formatter.args = ["--stdin" "%{buffer_name}"];
            auto-format = true;
          }))
          {
            dart.language-servers = ["dart" "codebook"];
            git-commit.language-servers = ["harper-ls" "codebook"];
            java.language-servers = ["jdtls" "codebook"];
            jjdescription.language-servers = ["harper-ls" "codebook"];
            markdown.language-servers = ["harper-ls" "codebook"];
            nu.language-servers = ["nu-lsp" "codebook"];
            qml.language-servers = ["qmlls" "codebook"];
            rust.language-servers = ["rust-analyzer" "codebook"];
            typst.language-servers = ["tinymist" "harper-ls" "codebook"];
            verilog.language-servers = ["verible-verilog-ls"];
          });

        languages.language-server = {
          codebook = {
            command = lib.getExe pkgs.codebook;
            args = ["serve"];
            config.globalConfigPath = (pkgs.formats.toml {}).generate "codebook.toml" {dictionaries = ["en_us" "en_gb" "de"];};
          };

          harper-ls.config.harper-ls.linters.SpellCheck = false;
          harper-ls.config.harper-ls.isolateEnglish = true;

          nixd.config.nixd.options = {
            flake-parts.expr = "(builtins.getFlake \"/etc/nixos\").debug.options";
            flake-parts-per-system.expr = "(builtins.getFlake \"/etc/nixos\").currentSystem.options";
            nixos.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.primary.options";
            home-manager.expr = "(builtins.getFlake \"/etc/nixos\").nixosConfigurations.primary.options.home-manager.users.type.getSubOptions []";
          };

          rust-analyzer.config = {
            assist.preferSelf = true;
            check.command = "clippy";
            completion.hideDeprecated = true;
            gotoImplementations.filterAdjacentDerives = true;
            hover.show.traitAssocItems = 5;
            references.excludeImports = true;
            references.excludeTests = true;
          };

          tinymist.config.tinymist.completion.symbol = "stepless";
          tinymist.config.tinymist.lint.enabled = true;

          verible-verilog-ls.command = "verible-verilog-ls";
          verible-verilog-ls.args = ["--rules=-always-comb,-explicit-parameter-storage-type"];
        };

        extraPackages = [pkgs.harper];
      }).wrapper;
  };

  nixos = moduleWithSystem (perSystem @ {config, ...}: {config, ...}: {
    options.cli.editor.enable = lib.mkEnableOption "Helix";

    config = lib.mkIf config.cli.editor.enable {
      hm.home.packages = [perSystem.config.packages.editor];
      hm.home.sessionVariables.EDITOR = "hx";
      core.impermanence.hm.directories = [".local/share/codebook/cache"];
    };
  });
}
