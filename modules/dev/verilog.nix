{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.dev.verilog.enable = lib.mkEnableOption "Verilog";

    config.cli.editor = lib.mkIf config.dev.verilog.enable {
      packages = [pkgs.verible];
      languages.verilog.language-servers = ["verible-verilog-ls"];
      languageServers.verible-verilog-ls.command = "verible-verilog-ls";
    };
  };
}
