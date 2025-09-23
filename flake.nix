{
  description = "My NixOS config as a Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=master";
    nix-flatpak.url = "github:gmodena/nix-flatpak";

    nixos-facter-modules.url = "github:numtide/nixos-facter-modules";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
      darwin,
      nix-homebrew,
      homebrew-bundle,
      homebrew-core,
      homebrew-cask,
      mac-app-util,
      ...
    }@inputs:
    {
      nixosConfigurations = {
        galago = nixpkgs.lib.nixosSystem {
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
      };

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
