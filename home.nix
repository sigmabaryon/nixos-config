{ config, pkgs, inputs, ... }:


{
  imports = [
    inputs.impermanence.nixosModules.home-manager.impermanence
  ];

  home.username = "bloomwhaler";
  home.homeDirectory = "/home/bloomwhaler";

  home.packages = with pkgs; [
    ripgrep
  ];

  home.persistence."/persist/state/home/bloomwhaler/general" = {
    directories = [
      ".ssh"
      ".mozilla"

      ".local/share/nvim"
      ".local/share/fish"

      ".local/state/nvim"
    ];
    files = [
      ".local/share/recently-used.xbel"
      ".local/share/user-places.xbel"
      ".local/share/user-places.xbel.bak"
      ".local/share/user-places.xbel.tbcache"
    ];
    allowOther = true;
  };

  home.persistence."/persist/state/home/bloomwhaler/dotfiles" = {
    directories = [
      ".config/kde.org"
      ".local/share/baloo"
      ".local/share/dolphin"
      ".local/share/kactivitymanagerd"
      ".local/share/kate"
      ".local/share/klipper"
      ".local/share/konsole"
      ".local/share/kwalletd"
      ".local/share/RecentDocuments"
      ".local/share/sddm"
    ];
    files = [
      ".config/kwinoutputconfig.json"
      ".config/kactivitymanagerd-pluginsrc"
      ".config/kactivitymanagerd-statsrc"
      ".config/kactivitymanagerd-switcher"
      ".config/kactivitymanagerdrc"
      ".config/baloofileinformationrc"
      ".config/baloofilerc"
      ".config/bluedevilglobalrc"
      ".config/device_automounter_kcmrc"
      ".config/dolphinrc"
      ".config/filetypesrc"
      ".config/katerc"
      ".config/kded5rc"
      ".config/kdeglobals"
      ".config/kglobalshortcutsrc"
      ".config/klaunchrc"
      ".config/konsolerc"
      ".config/ksplashrc"
      ".config/kscreenlockerrc"
      ".config/krunnerrc"
      ".config/kwalletrc"
      ".config/kwinrc"
      ".config/kwinrulesrc"
      ".config/mimeapps.list"
      ".config/plasma-localerc"
      ".config/plasma-nm"
      ".config/plasma-org.kde.plasma.desktop-appletsrc"
      ".config/plasmashellrc"
      ".config/PlasmaUserFeedback"
      ".config/powerdevilrc"
      ".config/powermanagementprofilesrc"
      ".config/spectaclerc"
      ".config/Trolltech.conf"
      ".config/user-dirs.dirs"
      ".config/user-dirs.locale"

      ".config/psd/psd.conf"
    ];
    allowOther = true;
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';
  };

  programs.fish = {
    enable = true;
  };

  programs.eza = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    extraOptions = [
      "--group-directories-first"
    ];
  };

  programs.fzf = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
  };

  programs.git = {
    enable = true;
    userName = "xxxx";
    userEmail = "xxxx";
    extraConfig = {
      init.defaultBranch = "main";
    };
    delta = {
      enable = true;
      options = {
        decorations = {
          commit-decoration-style = "bold yellow box ul";
          file-decoration-style = "none";
          file-style = "bold yellow ul";
        };
        features = "decorations";
      };
    };
  };

  programs.starship = {
    enable = true;
    enableFishIntegration = true;
    enableBashIntegration = true;
    settings = {
      add_newline = false;
      line_break.disabled = true;
    };
  };

  programs.kitty = {
    enable = true;
    shellIntegration.enableFishIntegration = true;
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
