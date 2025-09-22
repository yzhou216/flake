{ ... }:
{
  imports = [
    ./state-version.nix
    ../commons.nix
    ../../systems/darwin/default.nix
  ];

  system.primaryUser = "lexi";
  networking.hostName = "air";
}
