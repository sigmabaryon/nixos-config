{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  sops.defaultSopsFile = ./secrets/general.yaml;
  sops.age.sshKeyPaths = [ "/.persist/state/.keys/ssh/ssh_host_ed25519_key" ];
  sops.age.keyFile = "/.persist/state/.keys/sops-nix/key.txt";
  sops.age.generateKey = true;

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    supportedFilesystems = ["zfs"];
    zfs.forceImportRoot = false;
    kernelParams = [ "nohibernate" ];
    initrd = {
      systemd.enable = lib.mkDefault true;
      systemd.services.rollback = {
        description = "Rollback ZFS datasets to a pristine state";
        wantedBy = [
          "initrd.target"
        ];
        after = [
          "zfs-import-zroot.service"
        ];
        before = [
          "sysroot.mount"
        ];
        path = with pkgs; [
          zfs
        ];
        unitConfig.DefaultDependencies = "no";
        serviceConfig.Type = "oneshot";
        script = ''
          zfs rollback -r zroot/local/root@blank && echo "root rollback complete"
        '';
      };
    };
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  systemd.services.zfs-mount.enable = false;
  services.zfs = {
    autoScrub = {
      enable = true;
      interval = "weekly";
    };
    trim = {
      enable = true;
      interval = "weekly";
    };
  };

  networking.hostName = "wintermute";
  networking.hostId = "0D15EA5E";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Kolkata";
  i18n.defaultLocale = "en_IN";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_IN";
    LC_IDENTIFICATION = "en_IN";
    LC_MEASUREMENT = "en_IN";
    LC_MONETARY = "en_IN";
    LC_NAME = "en_IN";
    LC_NUMERIC = "en_IN";
    LC_PAPER = "en_IN";
    LC_TELEPHONE = "en_IN";
    LC_TIME = "en_IN";
  };

  security.apparmor.enable = true;
  security.apparmor.enableCache = true;
  security.sudo = {
    enable = true;
    extraRules = [{
      commands = [
        {
          command = "${pkgs.profile-sync-daemon}/bin/psd-overlay-helper";
          options = [ "NOPASSWD" ];
        }
      ];
      users = [ config.users.users.bloomwhaler.name ];
    }];
  };
  # security.audit.enable = true;
  # security.auditd.enable = true;
  # security.audit.rules = [
  #   "-A exclude,always -F msgtype=SERVICE_START"
  #   "-A exclude,always -F msgtype=SERVICE_STOP"
  #   "-A exclude,always -F msgtype=BPF"
  #   "-A exclude,always -F exe=/usr/bin/sudo"
  # ]

  hardware.opengl.enable = true;
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = true;
    dynamicBoost.enable = true;
    open = false;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
      	enable = true;
      	enableOffloadCmd = true;
      };
      nvidiaBusId = "PCI:1:0:0";
      amdgpuBusId = "PCI:7:0:0";
    };
  };

  zramSwap.enable = true;
  zramSwap.memoryPercent = 25;

  services.xserver.enable = true;
  services.xserver.xkb = {
    layout = "us";
  };
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    # alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  programs.firefox.enable = true;
  programs.virt-manager.enable = true;
  
  virtualisation = {
    libvirtd.enable = true;
    containers.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };

  services.flatpak.enable = true;

  sops.secrets.u_pass.neededForUsers = true;
  users.users.bloomwhaler = {
    isNormalUser = true;
    description = "";
    extraGroups = [ "networkmanager" "wheel" "libvirtd"];
    hashedPasswordFile = config.sops.secrets.u_pass.path;
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    wget
    podman-compose
    zfs
  ];

  fonts.packages = with pkgs; [
    ubuntu_font_family
    (nerdfonts.override { fonts = [ "Hack" ]; })
  ];
  # fonts.fontDir.enable = true; # for flatpaks

  programs.neovim.enable = true;
  programs.neovim.defaultEditor = true;

  fileSystems."/".neededForBoot = true;
  fileSystems."/home".neededForBoot = true;
  fileSystems."/.persist/state".neededForBoot = true;
  environment = {
    persistence."/.persist/state/root" = {
      hideMounts = true;
      directories = [
        "/etc/ssh"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
      ];
      files = [
        #"/etc/zfs/zpool.cache"
      ];
    };
  };
  programs.fuse.userAllowOther = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  services.psd.enable = true;
  services.openssh.enable = true;

  system.stateVersion = "24.05";
}
