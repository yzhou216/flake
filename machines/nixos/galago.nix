{ ... }:
{
  imports = [
    ./state-version.nix
    ../commons.nix
    ../../systems/graphic.nix
    ../../disko/bcachefs.nix
  ];

  hardware.system76.enableAll = true;
  networking.hostName = "galago";
}
