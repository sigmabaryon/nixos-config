# Command References

1. `NIX_CONFIG='experimental-features = nix-command flakes' nix-shell -p git neovim`

2. `nixos-generate-config --root /tmp/config --no-filesystems`

3. `echo '' > /tmp/pass-zpool-zroot`

4. `echo '' > /tmp/pass-zpool-zstore`

5. `sudo nix --experimental-features "nix-command flakes" run 'github:nix-community/disko#disko-install' -- --mode format --write-efi-boot-entries --flake '/tmp/config/etc/nixos#wintermute' --disk zdsk /dev/disk/by-id/nvme-xxxx --disk mdsk /dev/disk/by-id/nvme-xxxx`

6. `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode mount /tmp/config/etc/nixos/fs.nix`

7. `sudo nixos-enter --root /mnt -c 'passwd bloomwhaler'`

8. `umount -n -R /mnt`

9. `zpool export zroot`
10. `zpool export zstore`

# Future References:
- https://github.com/astro/microvm.nix/issues/52

## More
- Add SOPS encr
-
