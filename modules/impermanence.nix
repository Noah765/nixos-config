{
  lib,
  osOptions,
  hmOptions,
  ...
}:
{
  options.impermanence =
    let
      osOptions =
        (modules.evalModules {
          modules = [
            { _module.args.name = "/persist/system"; }
          ] ++ osOptions.environment.persistencec.type.nestedTypes.elemType.getSubModules;
        }).options;
      hmOptions = hmOptions.home.persistence.type.getSubOptions [ ];
    in
    {
      enable = mkEnableOption "impermanence";
      disk = mkOption {
        type = with lib.types; uniq str;
        example = "sda";
        description = "The disk for disko to manager and to use for impermanence.";
      };
      os = {
        directories = osOptions.directories;
        files = osOptions.files;
      };
      hm = {
        directories = hmOptions.directories;
        files = hmOptions.files;
      };
    };
}
