{ ... }:
{
  imports = [
    ./state-version.nix
    ../commons.nix
    ../../systems/nixos/graphic.nix
    ../../disko/bcachefs.nix
  ];

  hardware.system76.enableAll = true;
  networking.hostName = "galago";
}
