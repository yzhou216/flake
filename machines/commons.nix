{ pkgs, ... }:
{
  nix = {
    package = pkgs.lix; # Use the Lix implementation of Nix
    channel.enable = false;
    settings = {
      experimental-features = "nix-command flakes";
      nix-path = "nixpkgs=flake:nixpkgs";
      use-xdg-base-directories = true;
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];
    };
  };
}
