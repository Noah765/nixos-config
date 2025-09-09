{
  lib,
  inputs,
  pkgs,
  config,
  ...
}: {
  options.cli.editor.enable = lib.mkEnableOption "Neovim";

  config.hm.home = lib.mkIf config.cli.editor.enable {
    packages = [inputs.self.packages.${pkgs.system}.nvim];
    sessionVariables.EDITOR = "nvim";
  };
}
