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
      inputs.impermanence.nixosModules.default
      (lib.mkAliasOptionModule ["core" "impermanence" "os"] ["environment" "persistence" "/persist"])
      (lib.mkAliasOptionModule ["core" "impermanence" "hm"] ["environment" "persistence" "/persist" "users" "noah"])
    ];

    options.core.impermanence.enable = lib.mkEnableOption "automatic system cleanup using impermanence";
    options.core.impermanence.disk = lib.mkOption {
      type = lib.types.str;
      example = "nvme-CT1000P1SSD8_2026292B60BD";
      description = "The disk for disko to manage and to use for impermanence.";
    };

    config = lib.mkMerge [
      (lib.mkIf config.core.impermanence.enable {
        assertions = [{assertion = config.core.impermanence.disk != null;}];

        disko.devices.disk.main = {
          type = "disk";
          device = "/dev/disk/by-id/${config.core.impermanence.disk}";
          content.type = "gpt";
          content.partitions = {
            esp = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "128M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            swap.size = "8G";
            swap.content = {
              type = "swap";
              resumeDevice = true;
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

        boot.initrd.systemd.initrdBin = with pkgs; [btrfs-progs coreutils findutils util-linux];
        boot.initrd.systemd.services.prune-subvolumes = {
          unitConfig.DefaultDependencies = false;
          serviceConfig = {
            Type = "oneshot";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
          };
          requiredBy = ["initrd.target"];
          before = ["sysroot.mount"];
          requires = ["initrd-root-device.target"];
          after = ["initrd-root-device.target" "local-fs-pre.target"];
          script = ''
            mkdir /btrfs_tmp
            mount /dev/root /btrfs_tmp
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
        };

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

        programs.nh.clean.enable = true;
        programs.nh.clean.extraArgs = "--keep 3 --keep-since 7d";
      })
      (lib.mkIf (!config.core.impermanence.enable) {
        environment.persistence."/persist".enable = false;
      })
    ];
  };
}
