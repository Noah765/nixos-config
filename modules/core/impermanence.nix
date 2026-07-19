{
  lib,
  inputs,
  ...
}: {
  nixos = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      inputs.disko.nixosModules.default
      inputs.preservation.nixosModules.default
      (lib.mkAliasOptionModule ["core" "impermanence" "os"] ["preservation" "preserveAt" "/persist"])
      (lib.mkAliasOptionModule ["core" "impermanence" "hm"] ["preservation" "preserveAt" "/persist" "users" "noah"])
    ];

    options.core.impermanence = {
      enable = lib.mkEnableOption "automatic system cleanup using impermanence";
      disk = lib.mkOption {
        type = lib.types.str;
        example = "nvme-CT1000P1SSD8_2026292B60BD";
        description = "The disk for disko to manage and to use for impermanence.";
      };
      start = lib.mkOption {
        type = lib.types.str;
        default = "0";
        description = "Start of the NixOS partitions in sgdisk format.";
      };
    };

    config = lib.mkIf config.core.impermanence.enable {
      assertions = [{assertion = config.core.impermanence.disk != null;}];

      disko.devices.disk.main = {
        type = "disk";
        device = "/dev/disk/by-id/${config.core.impermanence.disk}";
        content.type = "gpt";
        content.partitions = {
          ESP = {
            type = "EF00";
            size = "128M";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
              mountOptions = ["umask=0077"];
            };
          };
          swap = {
            size = "8G";
            start = config.core.impermanence.start;
            content.type = "swap";
            content.resumeDevice = true;
          };
          root.size = "100%";
          root.content = {
            type = "btrfs";
            extraArgs = ["-f"];
            subvolumes = {
              "/root".mountOptions = ["noatime" "compress=zstd"];
              "/root".mountpoint = "/";
              "/persist".mountOptions = ["noatime" "compress=zstd"];
              "/persist".mountpoint = "/persist";
              "/nix".mountOptions = ["noatime" "compression=zstd"];
              "/nix".mountpoint = "/nix";
            };
          };
        };
      };

      fileSystems."/persist".neededForBoot = true;

      preservation.enable = true;
      preservation.preserveAt."/persist" = {
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
          {
            file = "/var/lib/systemd/random-seed";
            how = "symlink";
            inInitrd = true;
          }
          {
            file = "/var/lib/systemd/timesync/clock";
            inInitrd = true;
          }
        ];
        directories = [
          {
            directory = "/etc/nixos";
            user = "noah";
            group = "users";
          }
          "/var/lib/nixos"
          "/var/lib/systemd/timers"
          "/var/log"
        ];

        users.noah.directories = ["Documents" "Downloads" "Music" "Pictures" "Videos" "projects"];
      };

      systemd.services.systemd-machine-id-commit.unitConfig.ConditionFirstBoot = true;

      boot.initrd.systemd = {
        tmpfiles.settings.preservation."/sysroot/persist/etc/machine-id".f.argument = "uninitialized";

        initrdBin = [pkgs.btrfs-progs pkgs.findutils];
        services.prune-subvolumes = {
          unitConfig.DefaultDependencies = false;
          wantedBy = ["initrd.target"];
          requires = ["initrd-root-device.target"];
          after = ["initrd-root-device.target" "local-fs-pre.target"];
          before = ["sysroot.mount"];
          serviceConfig = {
            Type = "oneshot";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
          };
          script = ''
            mkdir -p /mnt
            mount -t btrfs /dev/disk/by-partlabel/disk-main-root /mnt
            mkdir -p /mnt/persist/old-roots

            for x in $(find /mnt/persist/old-roots -mindepth 1 -maxdepth 1 -mtime +7); do
              btrfs subvolume delete --recursive "$x"
            done

            if [ -e /mnt/root ]; then
              timestamp=$(date --reference /mnt/root '+%F_%T')
              mv /mnt/root "/mnt/persist/old-roots/$timestamp"
            fi

            btrfs subvolume create /mnt/root

            umount /mnt
          '';
        };
      };

      programs.nh.clean.enable = true;
      programs.nh.clean.extraArgs = "--keep 3 --keep-since 7d";
    };
  };
}
