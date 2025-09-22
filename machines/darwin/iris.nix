{ }:
{
  imports = [
    ./state-version.nix
    ../commons.nix
    ../../systems/darwin/default.nix
  ];

  system.primaryUser = "iris";
  networking.hostName = "m1";
}
