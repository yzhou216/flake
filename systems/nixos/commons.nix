{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../nixpkgs.nix
    ../bash.nix
    ../dev.nix
    ../vc.nix
    ../editors.nix
    ../man.nix
  ];

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

  nixpkgs.overlays = [
    (import (
      builtins.fetchTarball {
        url = "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
      }
    ))
  ];

  services = {
    pipewire.alsa = {
      enable = true;
      support32Bit = true;
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
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };

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
    tree
    zstd
    skim
    ffmpeg

    # network
    wget
    sshfs
    dumbpipe
    miniserve

    # spell checker
    aspell
    aspellDicts.en

    # manuals
    linux-manual

    # NixOS
    nixos-anywhere
    nixos-facter
    nix-init

    # TeX
    tectonic
    texlab
    lilypond-unstable-with-fonts
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
  };
}
