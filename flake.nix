{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixos-hardware.url = "nixos-hardware";
  };

  outputs = {
    self,
    nixpkgs,
    nixos-hardware,
  } @ inputs: {
    nixosConfigurations = {
      sys76 = nixpkgs.lib.nixosSystem {
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
  };
}
