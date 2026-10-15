{ lib, pkgs, ... }:
{
  nix = {
    # Use the Lix implementation of Nix
    # TODO: drop the override once nixpkgs stops passing `-Dmimalloc`
    # to Lix 2.95, which does not define that Meson option.
    package = pkgs.lix.overrideAttrs (old: {
      mesonFlags = lib.filter (flag: !lib.hasPrefix "-Dmimalloc=" flag) old.mesonFlags;
    });
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
