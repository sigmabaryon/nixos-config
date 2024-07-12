{ disks ? [ "/dev/disk/by-id/nvme-WDS500G3X0C-00SJG0_19426P459505" "/dev/disk/by-id/nvme-WDC_PC_SN730_SDBPNTY-1T00-1006_210205800881" ], ... }: {
  disko.devices = {
    disk = {
       zdsk = {
        type = "disk";
        device = builtins.elemAt disks 0;
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            root = {
              size = "476420M";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
          }; # partitions
        }; # content
      }; # zdsk
      mdsk = {
        type = "disk";
        device = builtins.elemAt disks 1;
        content = {
          type = "gpt";
          partitions = {
            mirror = {
              size = "476420M";
              content = {
                type = "zfs";
                pool = "zroot";
              };
            };
            store = {
	      start = "476431M";
              end = "-10M";
              content = {
                type = "zfs";
                pool = "zstore";
              };
            };
          }; # partitions
        }; # content
      }; # mdsk
    };#disk
    zpool = {
      zroot = {
        type = "zpool";
        mode = "mirror";
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          xattr = "sa";
          relatime = "on";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/pass-zpool-zroot";
          compression = "lz4";
          mountpoint = "none";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = ''
          zfs set keylocation="prompt" zroot
        '';
        options = {
          ashift = "12";
          autotrim = "on";
        };

        datasets = {
          local = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          persist = {
            type = "zfs_fs";
            options.mountpoint = "none";
          };
          "local/root" = {
            type = "zfs_fs";
            mountpoint = "/";
            options.mountpoint = "legacy";
            postCreateHook = ''
              zfs snapshot zroot/local/root@blank
            '';
          };
          "local/nix" = {
            type = "zfs_fs";
            mountpoint = "/nix";
            options = {
              atime = "off";
              mountpoint = "legacy";
            };
          };
          "local/nix-store" = {
            type = "zfs_fs";
            mountpoint = "/nix/store";
            options = {
              atime = "off";
              mountpoint = "legacy";
            };
          };
          "local/log" = {
            type = "zfs_fs";
            mountpoint = "/var/log";
            options.mountpoint = "legacy";
          };
          "local/flatpak" = {
            type = "zfs_fs";
            mountpoint = "/var/lib/flatpak";
            options = {
              atime = "off";
              mountpoint = "legacy";
            };
          };
          "local/home" = {
            type = "zfs_fs";
            mountpoint = "/home";
            options.mountpoint = "legacy";
            postCreateHook = ''
              zfs snapshot zroot/local/home@blank
            '';
          };
          "persist/containers" = {
            type = "zfs_fs";
            mountpoint = "/.persist/containers";
            options.mountpoint = "legacy";
          };
          "persist/libvirt" = {
            type = "zfs_fs";
            mountpoint = "/.persist/libvirt";
            options.mountpoint = "legacy";
          };
          "persist/state" = {
            type = "zfs_fs";
            mountpoint = "/.persist/state";
            options.mountpoint = "legacy";
          };
        }; # datasets
      }; # zroot
      zstore = {
        type = "zpool";
        rootFsOptions = {
          acltype = "posixacl";
          canmount = "off";
          xattr = "sa";
          relatime = "on";
          encryption = "aes-256-gcm";
          keyformat = "passphrase";
          keylocation = "file:///tmp/pass-zpool-zstore";
          compression = "lz4";
	  mountpoint = "none";
          "com.sun:auto-snapshot" = "false";
        };
        postCreateHook = ''
          zfs set keylocation="prompt" zstore
        '';
        options = {
          ashift = "12";
          autotrim = "on";
        };
        datasets = {
          store = {
            type = "zfs_fs";
            mountpoint = "/store";
            options.mountpoint = "legacy";
          };
          "store/gamelib" = {
            type = "zfs_fs";
            mountpoint = "/store/gamelib";
            options = {
              atime = "off";
              mountpoint = "legacy";
            };
          };
          "store/libvirt" = {
            type = "zfs_fs";
            mountpoint = "/store/libvirt";
            options.mountpoint = "legacy";
          };
          "store/tank" = {
            type = "zfs_fs";
            mountpoint = "/store/tank";
            options.mountpoint = "legacy";
          };
        }; # datasets
      }; # zstore
    }; # zpool
  };#devices
}

