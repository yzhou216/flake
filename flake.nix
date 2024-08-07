{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "nixos-hardware";

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
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
    darwin,
    nix-homebrew,
    homebrew-bundle,
    homebrew-core,
    homebrew-cask,
    ...
  } @ inputs: {
    nixosConfigurations = {
      galago = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          nixos-hardware.nixosModules.system76
          #.sys/BASE.nix
          ./sys/hardware-configuration.nix
          ./sys/configuration.nix
        ];
      };
    };

    darwinConfigurations = {
      m1 = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import nixpkgs {system = "aarch64-darwin";};
        modules = [
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
          ./modules/darwin
        ];
      };
    };
  };
}
