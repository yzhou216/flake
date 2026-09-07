{ pkgs, ... }:
{
  nix = {
    package = pkgs.lix; # Use the Lix implementation of Nix
    channel.enable = false;
    settings = {
      experimental-features = [
        "flakes"
        "nix-command"
      ];
      accept-flake-config = true;
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
