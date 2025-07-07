{
  pkgs,
  lib,
  ...
}:
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
    # Use iwd as the IEEE 802.11 backend for NetworkManager
    networkmanager.wifi.backend = "iwd";
    wireless.iwd = {
      enable = true;
      settings = {
        General.AddressRandomization = "once";
        IPv6.Enabled = true;
        Settings.AutoConnect = true;
      };
    };

    # Use nftables as the backend instead of iptables
    nftables.enable = true;
    firewall = {
      enable = true;
      package = pkgs.nftables;
      # Open ports in the firewall
      #allowedTCPPorts = [ ... ];
      #allowedUDPPorts = [ ... ];
    };

    # Network proxy
    #proxy.default = "http://user:password@proxy:port/";
    #proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

  time.timeZone = "America/Los_Angeles";

  # Internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = lib.genAttrs [
      "LC_ADDRESS"
      "LC_IDENTIFICATION"
      "LC_MEASUREMENT"
      "LC_MONETARY"
      "LC_NAME"
      "LC_NUMERIC"
      "LC_PAPER"
      "LC_TELEPHONE"
      "LC_TIME"
    ] (locale: "en_US.UTF-8");
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
      wireplumber.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };

      # JACK applications
      #jack.enable = true;
    };

    # Common UNIX Printing System
    printing.enable = true;

    # OpenSSH daemon
    openssh.enable = true;

    # Touchpad support (enabled default in most desktopManager)
    libinput.enable = true;

    guix = {
      enable = true;
      gc.enable = true;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "both";
      extraUpFlags = [ "--ssh" ];
    };

    keyd = {
      enable = true;
      keyboards.default = {
        ids = [ "*" ];
        settings = {
          main.capslock = "leftcontrol";
          "control"."[" = "esc";
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

  environment.systemPackages = with pkgs; [
    readline
    stow
    tree
    zstd
    ffmpeg

    # network
    wget
    sshfs
    dumbpipe
    miniserve

    # version control
    jujutsu

    # spell checker
    aspell
    aspellDicts.en

    # source code tagging
    universal-ctags
    cscope

    # toolchain
    gcc
    gdb
    gnumake
    cmake
    libtool

    # manuals
    man-pages
    man-pages-posix
    linux-manual

    # NixOS
    nixos-anywhere
    nixos-facter
    nix-init

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

    # Lisp
    guile
    akkuPackages.scheme-langserver
    racket
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
    jdt-language-server

    # WWW
    vscode-langservers-extracted

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

    # Forge clients
    codeberg-cli
    glab # GitLab CLI
    gh # GitHub CLI
  ];

  programs = {
    # GNU Privacy Guard
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    git = {
      enable = true;
      lfs.enable = true;
    };

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

    /*
      Some programs need SUID wrappers, can be configured further or
      are started in user sessions.
    */
    #mtr.enable = true;

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
