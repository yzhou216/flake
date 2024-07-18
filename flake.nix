{
  description = "A minimal flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable"; # nixos-22.11

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs @ {
    nixpkgs,
    home-manager,
    darwin,
    ...
  }: {
    darwinConfigurations.m1 = darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      pkgs = import nixpkgs {system = "aarch64-darwin";};
      modules = [
        ./modules/darwin
      ];
    };
  };
}
