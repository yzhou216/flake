{pkgs, ...}: {
  imports = [../commons.nix];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "galago";

    # Use iwd for networking
    networkmanager.enable = false;
    wireless = {
      iwd = {
        enable = true;
        settings = {
          IPv6 = {
            Enabled = true;
          };
          Settings = {
            AutoConnect = true;
          };
        };
      };
    };

    # Network proxy
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # firewall.enable = false;
  };

  time.timeZone = "America/Los_Angeles";

  # Internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true; # Allow unfree packages
      allowBroken = true; # Allow broken packages
    };

    overlays = [
      (import (builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }))
    ];
  };

  services = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      #jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #media-session.enable = true;
    };

    # Enable CUPS to print documents.
    printing.enable = true;

    # Enable the OpenSSH daemon.
    openssh.enable = true;

    # Enable touchpad support (enabled default in most desktopManager).
    libinput.enable = true;

    guix = {
      enable = true;
      gc.enable = true;
    };

    flatpak = {
      enable = true;
      update.onActivation = true;
      uninstallUnmanaged = true;
      packages = ["app.zen_browser.zen"];
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    keyd = {
      enable = true;
      keyboards.default = {
        ids = ["*"];
        settings = {
          main = {
            capslock = "layer(nav)";
            rightcontrol = "rightmeta";
          };
          "nav:C" = {
            "[" = "esc";
          };
        };
      };
    };

    emacs.package = pkgs.emacsUnstable;
  };

  hardware = {
    bluetooth.enable = true;
    bluetooth.powerOnBoot = true;

    acpilight.enable = true;
  };

  security = {
    # Use sudo-rs and doas instead of sudo
    sudo.enable = false;
    sudo-rs.enable = true;
    doas.enable = true;

    rtkit.enable = true;
  };

  # User account
  users.users.yiyu = {
    isNormalUser = true;
    description = "Yiyu Zhou";
    extraGroups = ["wheel" "video" "networkmanager"];
    packages = with pkgs; [
      firefox
      nyxt
      thunderbird
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    linux-manual

    gcc
    gdb
    gnumake
    cmake
    libtool
    readline
    git
    jujutsu
    sshfs

    emacs-git
    vim
    neovim

    universal-ctags
    cscope

    tmux
    wget
    stow
    tree
    unzip
    tectonic
    lilypond-unstable-with-fonts

    miniserve

    nixos-anywhere
    nixos-facter

    nil
    alejandra

    rustup
    bacon
    go
    gopls
    delve
    gofumpt
    golines
    guile
    rustpython
    uv
    pylyzer
    python313Packages.debugpy
    ihaskell # bin/ghci
    haskellPackages.stack
    haskellPackages.haskell-language-server
    temurin-bin-17

    sqlite
    sqls

    # Theming
    adwaita-icon-theme
    gnome-themes-extra
    libsForQt5.qt5ct
    qt6ct

    alacritty
    fragments
    digital
    libreoffice
    signal-desktop
    gurk-rs
    lutris
  ];

  programs = {
    htop.enable = true;
    direnv.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/yiyu/flake";
    };

    river = {
      enable = true;
      extraPackages = with pkgs; [
        pamixer
        kanshi
        yambar
        wofi
        fnott
        wayshot
        slurp
        wl-clipboard-rs
        swayidle
      ];
    };

    kdeconnect.enable = true;
    steam.enable = true;

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # mtr.enable = true;
    # gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # Remove new line character from default prompt PS1
    bash.promptInit = ''
      if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
          # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
          PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
          PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
          PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
      fi
    '';
  };

  documentation = {
    enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
    dev.enable = true;
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?
}
