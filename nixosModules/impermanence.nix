{
  inputs,
  hmConfig,
  lib,
  options,
  config,
  ...
}:
with lib;
let
  cfg = config.impermanence;
in
{
  imports = [
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
  ];

  options.impermanence =
    let
      persistenceOptions =
        (modules.evalModules {
          modules = [
            { _module.args.name = "/persist/system"; }
          ] ++ options.environment.persistence.type.nestedTypes.elemType.getSubModules;
        }).options;
    in
    {
      enable = mkEnableOption "impermanence";
      disk = mkOption {
        type = with types; uniq str;
        example = "sda";
        description = "The disk for disko to manage and to use for impermanence.";
      };
      directories = persistenceOptions.directories;
      files = persistenceOptions.files;
    };

  config = mkIf cfg.enable {
    assertions = [ { assertion = cfg.disk != null; } ]; # The disk option may not be set otherwise, this assertion never actually fails, but forces nix to evaluate cfg.disk

    disko.devices = {
      disk.main = {
        device = "/dev/${cfg.disk}";
        type = "disk";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              name = "boot";
              size = "1M";
              type = "EF02";
            };
            esp = {
              name = "ESP";
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountOptions = [ "umask=0077" ];
                mountpoint = "/boot";
              };
            };
            swap = {
              size = "4G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              name = "root";
              size = "100%";
              content = {
                type = "lvm_pv";
                vg = "root_vg";
              };
            };
          };
        };
      };
      lvm_vg.root_vg = {
        type = "lvm_vg";
        lvs.root = {
          size = "100%FREE";
          content = {
            type = "btrfs";
            extraArgs = [ "-f" ];
            subvolumes = {
              "/root".mountpoint = "/";
              "/persist" = {
                mountOptions = [
                  "subvol=persist"
                  "noatime"
                ];
                mountpoint = "/persist";
              };
              "/nix" = {
                mountOptions = [
                  "subvol=nix"
                  "noatime"
                ];
                mountpoint = "/nix";
              };
            };
          };
        };
      };
    };

    boot.initrd.postDeviceCommands = lib.mkAfter ''
      mkdir /btrfs_tmp
      mount /dev/root_vg/root /btrfs_tmp
      if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
        mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
      fi

      delete_subvolume_recursively() {
        IFS=$'\n'
        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
          delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
      }

      for i in $(find /btrfs_tmp/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30); do
        delete_subvolume_recursively "$i"
      done

      btrfs subvolume create /btrfs_tmp/root
      umount /btrfs_tmp
    '';

    fileSystems."/persist".neededForBoot = true;
    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/var/log"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/nixos"
      ] ++ cfg.directories;
      files = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory.mode = "u=rwx,g=,o=";
        }
      ] ++ cfg.files;
    };

    systemd.tmpfiles.rules = mkIf (hmConfig.impermanence.enable or false) [
      "d /persist/home 0700 noah users -"
    ];
    programs.fuse.userAllowOther = mkIf (hmConfig.impermanence.enable or false) true;
  };
}
