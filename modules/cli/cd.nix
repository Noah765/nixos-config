{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.cd.enable = lib.mkEnableOption "zoxide";

    config = lib.mkIf config.cli.cd.enable {
      environment.systemPackages = [pkgs.zoxide];
      cli.nushell.extraConfig = "source ${pkgs.runCommandLocal "zoxide.nu" {} "${lib.getExe pkgs.zoxide} init --cmd cd nushell > \"$out\""}";
      core.impermanence.hm.directories = [".local/share/zoxide"];
    };
  };
}
