{
  lib,
  inputs,
  useHm,
  config,
  ...
}:
with lib; let
  cfg = config.core.impermanence;
in {
  inputs = {
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence.url = "github:nix-community/impermanence";
  };

  imports = [
    (mkAliasOptionModule ["core" "impermanence" "os"] ["os" "environment" "persistence" "/persist/system"])
    (mkAliasOptionModule ["core" "impermanence" "hm"] ["hm" "home" "persistence" "/persist/home"])
  ];
  osImports = [
    inputs.disko.nixosModules.default
    inputs.impermanence.nixosModules.impermanence
  ];
  hmImports = [inputs.impermanence.nixosModules.home-manager.impermanence];

  options.core.impermanence = {
    enable = mkEnableOption "automatic system cleanup using impermanence";

    disk = mkOption {
      type = with types; uniq str;
      example = "sda";
      description = "The disk for disko to manager and to use for impermanence.";
    };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      assertions = [{assertion = cfg.disk != null;}];

      os = {
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
                    mountOptions = ["umask=0077"];
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
                extraArgs = ["-f"];
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

        boot.initrd.systemd.services.impermanence = {
          description = "Creates a new root subvolume and gradually deletes old ones.";
          wantedBy = ["initrd.target"];
          after = ["initrd-root-device.target"];
          before = ["sysroot.mount"];
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
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
        };

        fileSystems."/persist".neededForBoot = true;
        environment.persistence."/persist/system" = {
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
          files = [
            "/etc/machine-id"
            {
              file = "/var/keys/secret_file";
              parentDirectory.mode = "u=rwx,g=,o=";
            }
            "/etc/ssh/ssh_host_ed25519_key"
            "/etc/ssh/ssh_host_ed25519_key.pub"
          ];
        };

        nix.settings.auto-optimise-store = true;

        programs.nh = {
          enable = true;
          clean = {
            enable = true;
            extraArgs = "-k 5 -K 30d";
          };
        };

        systemd.tmpfiles.rules = mkIf useHm ["d /persist/home 0700 noah users -"];
        programs.fuse.userAllowOther = mkIf useHm true;
      };

      hm.home.persistence."/persist/home" = {
        allowOther = true;
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Documents"
          "Videos"
          "projects"
        ];
      };
    })
    (mkIf (!cfg.enable) {
      os.environment.persistence."/persist/system".enable = false;
      hm.home.persistence."/persist/home".enable = false;
    })
  ];
}
