{ ... }:
{
  nixpkgs.config = {
    allowUnfree = true; # Allow unfree packages
    allowBroken = true; # Allow broken packages
    allowUnsupportedSystem = true;
  };
}
