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
              "/nix".mountOptions = ["noatime" "compress=zstd"];
              "/nix".mountpoint = "/nix";
            };
          };
        };
      };

      fileSystems."/persist".neededForBoot = true;

      preservation.enable = true;
      core.impermanence = {
        os.files = [
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
        os.directories = [
          {
            directory = "/etc/nixos";
            user = "noah";
            group = "users";
          }
          "/var/lib/nixos"
          "/var/lib/systemd/timers"
          "/var/log"
        ];

        hm.directories = ["Documents" "Downloads" "Music" "Pictures" "Videos" "projects"];
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

            for x in $(find /mnt/persist/old-roots -mindepth 1 -maxdepth 1 -mtime +6); do
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

      core.cleanup.script = let
        validPaths =
          map (x: "." + x.file) (config.core.impermanence.os.files ++ config.core.impermanence.hm.files)
          ++ map (x: "." + x.directory) (config.core.impermanence.os.directories ++ config.core.impermanence.hm.directories)
          ++ ["./old-data" "./old-roots"];

        ancestors = x:
          if x == "."
          then []
          else [(lib.dirOf x)] ++ ancestors (lib.dirOf x);
        ancestorPaths = lib.uniqueStrings (lib.flatten (map ancestors validPaths));

        findExpression = paths: lib.join " -o " (map (x: "-path " + lib.escapeShellArg x) paths);
      in ''
        cd /persist
        mkdir -p old-data

        for x in $(find old-data -mindepth 1 -maxdepth 1 -mtime +6); do
          rm -r "$x"
        done

        timestamp=$(date '+%F_%T')
        for x in $(find '(' ${findExpression validPaths} ')' -prune -o ${findExpression ancestorPaths} -o -prune -print); do
          mkdir -p "old-data/$timestamp/''${x%/*}"
          mv "$x" "old-data/$timestamp/$x"
        done
      '';
    };
  };
}
