{
  config,
  pkgs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking = {
    hostName = "galago";
    # Network proxy
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Use iwd for networking
    networkmanager.enable = false;
    wireless.iwd.enable = true;
    wireless.iwd.settings = {
      IPv6 = {
        Enabled = true;
      };
      Settings = {
        AutoConnect = true;
      };
    };

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

  services = {
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

    tailscale.enable = true;
    tailscale.useRoutingFeatures = "client";
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

    # Enable touchpad support (enabled default in most desktopManager).
    # xserver.libinput.enable = true;

    emacs.package = pkgs.emacsUnstable;
  };

  nixpkgs.overlays = [
    (import (builtins.fetchTarball {
      url = https://github.com/nix-community/emacs-overlay/archive/master.tar.gz;
    }))
  ];

  hardware = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;

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
      thunderbird
    ];
  };

  nixpkgs.config.allowUnfree = true; # Allow unfree packages
  nixpkgs.config.allowBroken = true; # Allow broken packages

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    gcc
    gdb
    gnumake
    cmake
    libtool
    readline
    git

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

    nil
    alejandra

    rustup
    go
    gopls
    delve
    guile
    python3
    python312Packages.pip
    python312Packages.python-lsp-server
    python312Packages.debugpy
    temurin-bin-17

    river
    pamixer
    kanshi
    yambar
    wofi
    fnott
    wayshot
    slurp
    wl-clipboard-rs
    swayidle

    # Theming
    adwaita-icon-theme
    gnome-themes-extra
    qt5ct
    qt6ct

    alacritty
    digital
    libreoffice
    signal-desktop
    gurk-rs
    lutris
  ];

  programs = {
    htop.enable = true;
    nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 4d --keep 3";
      flake = "/home/yiyu/flake";
    };
    sway.enable = true; # backup for river
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

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.11"; # Did you read the comment?

  nix.settings = {
    experimental-features = "nix-command flakes";
    auto-optimise-store = true;
    trusted-users = ["root" "@wheel"];
  };
}
