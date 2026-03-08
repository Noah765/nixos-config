{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.dev.rust.enable = lib.mkEnableOption "Rust";

    config = lib.mkIf config.dev.rust.enable {
      core.impermanence.hm.directories = [".cargo"];

      cli.editor = {
        packages = with pkgs; [clippy rust-analyzer rustc];

        languages.rust.language-servers = ["rust-analyzer" "codebook"];

        languageServers.rust-analyzer.config = {
          assist.preferSelf = true;
          check.command = "clippy";
          completion.hideDeprecated = true;
          completion.termSearch.enable = true;
          diagnostics.styleLints.enable = true;
          gotoImplementations.filterAdjacentDerives = true;
          hover.show.traitAssocItems = 5;
          imports.preferPrelude = true;
          references.excludeImports = true;
          references.excludeTests = true;
        };
      };
    };
  };
}
