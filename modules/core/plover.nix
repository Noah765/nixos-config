{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.core.plover;
in {
  inputs.plover = {
    url = "github:LilleAila/plover-flake/linux-uinput-fixed"; # TODO Change to dnaq's repo once https://github.com/openstenoproject/plover/pull/1679 is merged
    inputs.nixpkgs.follows = "nixpkgs";
  };

  options.core.plover.enable = mkEnableOption "Plover, a free and open source stenography engine";

  config = mkIf cfg.enable {
    core.user.groups = ["input"];
    os = {
      hardware.uinput.enable = false;
      services.udev.extraRules = ''KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"'';
    };

    hm = {
      home.packages = [(inputs.plover.packages.${pkgs.system}.default.with-plugins (ps: [ps.plover-lapwing-aio]))];

      xdg.configFile = {
        "plover/plover.cfg".text = generators.toINI {} {System.name = "Lapwing";};

        "plover/user.json".text = generators.toJSON {} {};
      };
    };
  };
}
