{
  lib,
  inputs,
  ...
}: {
  nixos = {config, ...}: {
    imports = [
      inputs.disko.nixosModules.default
      inputs.impermanence.nixosModules.default
      (lib.mkAliasOptionModule ["core" "impermanence" "os"] ["environment" "persistence" "/persist"])
      (lib.mkAliasOptionModule ["core" "impermanence" "hm"] ["environment" "persistence" "/persist" "users" "noah"])
    ];

    options.core.impermanence.enable = lib.mkEnableOption "automatic system cleanup using impermanence";

    options.core.impermanence.disk = lib.mkOption {
      type = lib.types.uniq lib.types.str;
      example = "sda";
      description = "The disk for disko to manager and to use for impermanence.";
    };

    config = lib.mkMerge [
      (lib.mkIf config.core.impermanence.enable {
        assertions = [{assertion = config.core.impermanence.disk != null;}];

        disko.devices.disk.main = {
          device = "/dev/${config.core.impermanence.disk}";
          type = "disk";
          content.type = "gpt";
          content.partitions = {
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
                mountOptions = ["umask=0077"];
                mountpoint = "/boot";
              };
            };
            swap.size = "4G";
            swap.content = {
              type = "swap";
              resumeDevice = true;
            };
            root = {
              name = "root";
              size = "100%";
              content.type = "lvm_pv";
              content.vg = "root_vg";
            };
          };
        };
        disko.devices.lvm_vg.root_vg = {
          type = "lvm_vg";
          lvs.root.size = "100%FREE";
          lvs.root.content = {
            type = "btrfs";
            extraArgs = ["-f"];
            subvolumes = {
              "/root".mountpoint = "/";
              "/persist".mountOptions = ["subvol=persist" "noatime"];
              "/persist".mountpoint = "/persist";
              "/nix".mountOptions = ["subvol=nix" "noatime"];
              "/nix".mountpoint = "/nix";
            };
          };
        };

        boot.initrd.postResumeCommands = lib.mkAfter ''
          mkdir /btrfs_tmp
          mount /dev/root_vg/root /btrfs_tmp
          if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %X /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
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
        environment.persistence."/persist" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            {
              directory = "/etc/nixos";
              user = "noah";
              group = "users";
            }
          ];
          files = ["/etc/machine-id"];

          users.noah.directories = [
            "Downloads"
            "Music"
            "Pictures"
            "Documents"
            "Videos"
            "projects"
          ];
        };

        programs.nh.enable = true;
        programs.nh.clean = {
          enable = true;
          extraArgs = "--keep 5 --keep-since 7d --optimise";
        };
      })
      (lib.mkIf (!config.core.impermanence.enable) {
        environment.persistence."/persist".enable = false;
      })
    ];
  };
}
