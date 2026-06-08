{lib, ...}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    options.cli.cd.enable = lib.mkEnableOption "zoxide";

    config = lib.mkIf config.cli.cd.enable {
      nixpkgs.overlays = [(_: prev: {zoxide = prev.zoxide.override {withFzf = false;};})];
      environment.systemPackages = [pkgs.zoxide];
      core.impermanence.hm.directories = [".local/share/zoxide"];
    };
  };
}
