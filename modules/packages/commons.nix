{ pkgs, ... }:
{
  # Bootloader
  boot = {
    kernelPackages = pkgs.linuxPackages_testing;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  networking = {
    # Use iwd as the WiFi backend for NetworkManager
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings = {
        General.AddressRandomization = true;
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
    };

    # Use nftables as the backend instead of iptables
    nftables.enable = true;
    firewall = {
      enable = true;
      package = pkgs.nftables;
      # Open ports in the firewall.
      # allowedTCPPorts = [ ... ];
      # allowedUDPPorts = [ ... ];
    };

    # Network proxy
    # proxy.default = "http://user:password@proxy:port/";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
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
      (import (
        builtins.fetchTarball {
          url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
        }
      ))
    ];
  };

  services = {
    # Enable sound with pipewire.
    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      pulse.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
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

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
      extraUpFlags = [
        "--advertise-exit-node"
        "--exit-node-allow-lan-access"
        "--ssh"
      ];
    };

    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
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
  };

  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
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
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
    ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    linux-manual

    nixos-anywhere
    nixos-facter

    wget
    stow
    tree
    unzip
    sshfs
    miniserve

    universal-ctags
    cscope
    ispell

    gcc
    gdb
    gnumake
    cmake
    libtool
    readline
    git
    jujutsu

    # Bash
    bash-language-server
    shfmt

    # TeX
    tectonic
    texlab
    lilypond-unstable-with-fonts

    # Rust
    rustup
    bacon
    dioxus-cli

    # Go
    go
    gopls
    delve
    gofumpt
    golines
    guile

    # Common Lisp
    sbcl

    # Python
    rustpython
    uv
    pylyzer
    python313Packages.debugpy

    # Haskell
    ihaskell # bin/ghci
    haskellPackages.stack
    haskellPackages.haskell-language-server

    # Java
    temurin-bin # OpenJDK

    # SQL
    sqlite
    sqls

    # Markdown
    glow
    marksman

    # Nix
    nil
    nixfmt-rfc-style
    devenv
  ];

  programs = {
    vim.enable = true;
    neovim.enable = true;
    tmux.enable = true;
    htop.enable = true;
    direnv.enable = true;
    nh = {
      enable = true;
      flake = "/home/yiyu/.config/flake";
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };

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
}
