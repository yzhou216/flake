{
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ../nixpkgs.nix
    ../shell.nix
    ../dev.nix
    ../vc.nix
    ../editors.nix
    ../man.nix
  ];

  # Bootloader
  boot = {
    kernelPackages = pkgs.linuxPackages_testing;

    # Give back the halted TD on a disconnected root port, fixing the
    # HHKB hang after a replug into a laptop port on 7.3-rc
    # TODO: remove once the patch is merged upstream
    kernelPatches = [
      {
        name = "xhci-give-back-halted-td-on-disconnect";
        # https://lore.kernel.org/linux-usb/20261013073825.17962-1-yiyu@yiyuzhou.io/
        patch = pkgs.fetchpatch {
          url = "https://github.com/yzhou216/linux/commit/fa96503d2513b31a69c26b128c3d85ccbb027e3d.patch";
          hash = "sha256-OS89ibgsNWPf1f0gYEUe22715I34vJPKKiZR6ywCcs4=";
        };
      }
    ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
  };

  zramSwap.enable = true;

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

    (final: prev: {
      emacs-git = prev.emacs-git.overrideAttrs (
        _: _: {
          src = builtins.fetchGit {
            url = "https://github.com/emacsmirror/emacs.git";
            ref = "master";
          };
        }
      );

      emacs-unstable = prev.emacs-unstable.overrideAttrs (
        _: _: {
          src = final.emacs-git.src;
        }
      );
    })
  ];

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
  };

  services = {
    snapper.configs.home = {
      SUBVOLUME = "/home/yiyu";
      FSTYPE = "bcachefs";
      ALLOW_USERS = [ "yiyu" ];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;

      # Keep one day of hourly and three days of daily snapshots
      TIMELINE_LIMIT_HOURLY = 24;
      TIMELINE_LIMIT_DAILY = 3;
      TIMELINE_LIMIT_MONTHLY = 0;
      TIMELINE_LIMIT_YEARLY = 0;
    };

    automatic-timezoned.enable = true;

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
      extraSetFlags = [
        "--exit-node-allow-lan-access=true"
        "--operator=yiyu"
        "--ssh"
      ];
    };

    # Web GUI for LLM programming agents, reachable over the network
    t3code = {
      enable = true;
      user = "yiyu";
      host = "0.0.0.0";
      openFirewall = true;
    };

    # BitTorrent daemon with an HTTP API and web UI on localhost:3030
    rqbit = {
      enable = true;
      user = "yiyu";
      group = "users";
      downloadDir = "/home/yiyu/Downloads";
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

  # Download directory of rqbit, which must exist before it starts
  systemd.tmpfiles.settings."10-rqbit"."/home/yiyu/Downloads".d = {
    user = "yiyu";
    group = "users";
    mode = "0755";
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
    sudo-rs = {
      enable = true;
      extraConfig = ''
        Defaults !pwfeedback
      '';
    };

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
      "podman"
    ];

    # mkpasswd -m sha-512 <the_most_secure_password>
    hashedPassword = "$6$yM8t/1VCAl66Y7XD$dmvt7Xq6iGLU3uJ9lcpUvr/7PZxt7IzYsoZbm4s42pejndU4IAMW4YbP4JcQK5KxI5DzSwLjPFCYY/OETznnO1";
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

    # typesetting
    tectonic
    texlab
    lilypond-unstable-with-fonts
    pandoc
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

    htop = {
      enable = true;
      settings.show_program_path = false;
    };

    nh = {
      enable = true;
      flake = "/home/yiyu/.config/flake";
      clean = {
        enable = true;
        extraArgs = "--keep-since 4d --keep 3";
      };
    };

    nix-index.enable = true;

    /*
      Some programs need SUID wrappers, can be configured further or
      are started in user sessions.
    */
    #mtr.enable = true;
  };
}
