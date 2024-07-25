{ disks ? [ "/dev/vda" ], ... }: {
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
    };#disk
    zpool = {
      zroot = {
        type = "zpool";
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
          "persist/state" = {
            type = "zfs_fs";
            mountpoint = "/persist/state";
            options.mountpoint = "legacy";
          };
          "persist/main" = {
            type = "zfs_fs";
            mountpoint = "/persist/main";
            options.mountpoint = "legacy";
          };
        }; # datasets
      }; # zroot
    }; # zpool
  };#devices
}

