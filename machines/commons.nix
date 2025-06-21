{ pkgs, ... }:
{
  nix = {
    package = pkgs.lix; # Use the Lix implementation of Nix
    channel.enable = false;
    settings = {
      experimental-features = "nix-command flakes repl-flake";
      nix-path = "nixpkgs=flake:nixpkgs";
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
