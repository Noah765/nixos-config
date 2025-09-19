{
  lib,
  pkgs,
  config,
  ...
}: {
  options.cli.editor.spell-checking.enable = lib.mkEnableOption "english and german spell checking";

  config.cli.editor.settings = lib.mkIf config.cli.editor.spell-checking.enable {
    opts.spell = true;
    opts.spelllang = "en,de";
    extraFiles."spell/de.utf-8.spl".source = pkgs.fetchurl {
      url = "https://ftp.nluug.nl/pub/vim/runtime/spell/de.utf-8.spl";
      hash = "sha256-c8cQfqM5hWzb6SHeuSpFk5xN5uucByYdobndGfaDo9E=";
    };
  };
}
