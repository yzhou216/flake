{
  description = "My NixOS config as a Flake";

  nixConfig = {
    substituters = [
      "https://cache.nixos.org"
      "https://nix-community.cachix.org"
      "https://yzhou216.cachix.org"
    ];

    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "yzhou216.cachix.org-1:O7nGwQnLGGBGE8zYFMipVzPVN956FcV57y9SqwEP+O8="
    ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    disko = {
      # TODO: revert to master once
      # https://github.com/nix-community/disko/pull/1277 is merged
      url = "github:nix-community/disko/6747342da148f6cb28c8405a70fe00455a0ba027";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    openwrt-imagebuilder.url = "github:astro/nix-openwrt-imagebuilder";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    homebrew-bundle = {
      url = "github:homebrew/homebrew-bundle";
      flake = false;
    };

    mac-app-util.url = "github:hraban/mac-app-util";
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-flatpak,
      nixos-facter-modules,
      disko,
      openwrt-imagebuilder,
      darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      mac-app-util,
      ...
    }@inputs:
    let
      /*
        Nixpkgs master with commits from open pull requests applied on
        top.  Each commit is pinned so that pushes to a pull request do
        not invalidate the hashes.  Evaluating a system from the
        patched tree imports from a derivation, so the patched source
        is built before evaluation.

        TODO: remove the patches of each pull request once it is
        merged, and go back to `nixpkgs.lib.nixosSystem` once none are
        left.
      */
      nixpkgs-patched =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          fetchPrCommit =
            pr: rev: hash:
            pkgs.fetchpatch {
              url = "https://github.com/NixOS/nixpkgs/commit/${rev}.patch";
              inherit hash;
            };
        in
        pkgs.applyPatches {
          name = "nixpkgs-patched";
          src = nixpkgs;
          patches = [
            # https://github.com/NixOS/nixpkgs/pull/550395
            # nixos/river: init
            (fetchPrCommit 550395 "e0158f7c4876e3a5785a8f6f9582220c72a2d3ca" "sha256-u51R02kTwqGfBAn30xt//qpSlkAxIJ06/1etKsNNpv4=")
            # kwm: init at 0.3.0
            (fetchPrCommit 550395 "c08b9ab09a451370fecb4c9fb066524f5c302b34" "sha256-jGFJ/ukFauntI2RRosyA3JVFQvhj5ARErDlYtIBEk9U=")
            # nixos/kwm: init
            (fetchPrCommit 550395 "95213484d31f167321bcf01af375f77c57fa538b" "sha256-WC4SVSAivKi8SX4L6dFsq0n5BAgnJjuPnAQrLwsrB6g=")
            # kwim: init at 0.2.0
            (fetchPrCommit 550395 "a6846d48060dd112964e2ee55935692f8838bf5e" "sha256-sfZC7jThRQhnaBwBw/dw2EQXUzP3YwKDS6tzV2YVC44=")

            # https://github.com/NixOS/nixpkgs/pull/566470
            # maintainers: add jakob1379
            (fetchPrCommit 566470 "094265f353ac97584592b65fdcade927cd628c4e" "sha256-Y+QRgmLs6ooXo0N0YGWhRVaHP5pqK6zf5bNMbi7k9Xg=")
            # nixos/t3code: init
            (fetchPrCommit 566470 "c73e1fccfdf1e52182d9693b645587e3f4c27310" "sha256-C8WLiZVYUaPYhH7bKRYriy0+FpT9MWYiCeAmDUKeSz0=")
          ];
        };

      # Same as `nixpkgs.lib.nixosSystem`, but from the patched tree
      nixosSystem-patched =
        args:
        import "${nixpkgs-patched}/nixos/lib/eval-config.nix" (
          {
            lib = import "${nixpkgs-patched}/lib";
            system = null;
          }
          // args
          // {
            modules = args.modules ++ [ { config.nixpkgs.flake.source = nixpkgs-patched.outPath; } ];
          }
        );
    in
    {
      nixosConfigurations = {
        galago = nixosSystem-patched {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            nixos-facter-modules.nixosModules.facter
            {
              config.facter.reportPath =
                if builtins.pathExists ./machines/nixos/facter/galago.json then
                  ./machines/nixos/facter/galago.json
                else
                  throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
            }
            disko.nixosModules.disko
            ./machines/nixos/galago.nix
          ];
        };

        /*
          When testing out in an VM, `$ nixos-rebuild build-vm --flake
          .#router` won't work, since it builds the stock
          `system.build.vm`, which boots an empty overlay root and
          ignores the disko layout entirely (no bcachefs partitions,
          no swap, and no mounted subvolumes).  It also fails pure
          evaluation, because importing
          `../../systems/nixos/commons.nix` pulls in the emacs-overlay
          `fetchTarball` without a pinned `sha256`.  Instead, build a
          VM backed by a real disko image, which boots the actual
          bcachefs/swap layout:
          `$ nix build .#nixosConfigurations.router.config.system.build.vmWithDisko --impure`
        */
        router = nixosSystem-patched {
          system = "x86_64-linux";
          specialArgs = { inherit inputs; };
          modules = [
            nix-flatpak.nixosModules.nix-flatpak
            nixos-facter-modules.nixosModules.facter
            {
              config.facter.reportPath =
                if builtins.pathExists ./machines/nixos/facter/router.json then
                  ./machines/nixos/facter/router.json
                else
                  throw "Have you forgotten to run nixos-anywhere with `--generate-hardware-config nixos-facter ./facter.json`?";
            }
            disko.nixosModules.disko
            ./machines/nixos/router.nix
          ];
        };

        # nix build .#nixosConfigurations.bcachefs-iso.config.system.build.isoImage
        bcachefs-iso = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
            (
              {
                lib,
                pkgs,
                ...
              }:
              {
                boot.supportedFilesystems.bcachefs = true;
                isoImage.squashfsCompression = "zstd";
                zramSwap.enable = true;

                nix = {
                  package = pkgs.lix;
                  channel.enable = false;
                  settings = {
                    experimental-features = "nix-command flakes";
                    nix-path = "nixpkgs=flake:nixpkgs";
                    use-xdg-base-directories = true;
                    auto-optimise-store = true;
                  };
                };

                services = {
                  openssh.enable = true;
                  desktopManager.cosmic.enable = true;
                  displayManager.cosmic-greeter.enable = true;
                };

                programs = {
                  git.enable = true;
                  neovim.enable = true;
                  tmux.enable = true;

                  htop = {
                    enable = true;
                    settings.show_program_path = false;
                  };

                  firefox = {
                    enable = true;
                    package = pkgs.librewolf;
                  };
                };

                networking = {
                  networkmanager.wifi.backend = "iwd";
                  wireless.iwd = {
                    enable = true;
                    settings = {
                      IPv6.Enabled = true;
                      Settings.AutoConnect = true;
                    };
                  };
                };

                environment.systemPackages = with pkgs; [
                  bcachefs-tools
                  disko
                  dumbpipe
                  nixos-anywhere
                  nixos-facter
                  sendme
                  skim
                  tree
                  wget
                  zstd
                ];
              }
            )
          ];
        };
      };

      # nix build .#bcachefs-iso
      packages.x86_64-linux.bcachefs-iso =
        self.nixosConfigurations.bcachefs-iso.config.system.build.isoImage;

      # nix build .#openwrt
      packages.x86_64-linux.openwrt =
        let
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          profiles = openwrt-imagebuilder.lib.profiles { inherit pkgs; };
          config = profiles.identifyProfile "avm_fritz7412" // {
            # Packages to include in the image instead of installing them later
            packages = [ "tcpdump" ];

            disabledServices = [ "dnsmasq" ];

            /*
              Files to include in the image.  UCI configuration is set
              with a uci-defaults script, as the OpenWrt Image Builder
              documentation recommends.
            */
            files = pkgs.runCommand "image-files" { } ''
              mkdir -p $out/etc/uci-defaults
              cat > $out/etc/uci-defaults/99-custom <<EOF
              uci -q batch << EOI
              set system.@system[0].hostname='testap'
              commit
              EOI
              EOF
            '';
          };
        in
        openwrt-imagebuilder.lib.build config;

      darwinConfigurations = {
        iris = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            mac-app-util.darwinModules.default
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "iris";
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                };

                # Enable fully-declarative tap management
                # Taps can no longer be added imperatively with `brew tap`
                mutableTaps = false;
              };
            }
            ./machines/darwin/iris.nix
          ];
        };

        lexi = darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          modules = [
            mac-app-util.darwinModules.default
            nix-homebrew.darwinModules.nix-homebrew
            {
              nix-homebrew = {
                enable = true;
                enableRosetta = true;
                user = "lexi";
                taps = {
                  "homebrew/homebrew-core" = inputs.homebrew-core;
                  "homebrew/homebrew-cask" = inputs.homebrew-cask;
                  "homebrew/homebrew-bundle" = inputs.homebrew-bundle;
                };

                # Enable fully-declarative tap management
                # Taps can no longer be added imperatively with `brew tap`
                mutableTaps = false;
              };
            }
            ./machines/darwin/lexi.nix
          ];
        };
      };
    };
}
