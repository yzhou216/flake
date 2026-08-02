{ pkgs, lib, ... }:
{
  imports = [
    ./state-version.nix
    ../commons.nix
    ../../systems/nixos/commons.nix
    ../../disko/bcachefs.nix
  ];

  services.dnsmasq.enable = true;
  networking.hostName = "router";

  /*
    The disko image-builder VM builds its initrd from in-tree kernel
    modules only, but nixpkgs ships bcachefs as an out-of-tree module
    (pkgs.linuxPackages.bcachefs).  Merge it into the kernel module
    tree and regenerate modules.dep so the builder's initrd can find
    it.
  */
  disko.imageBuilder = {
    extraRootModules = [ "bcachefs" ];
    kernelPackages = pkgs.linuxPackages // {
      kernel = pkgs.linuxPackages.kernel // {
        modules = pkgs.buildEnv {
          name = "kernel-modules-with-bcachefs";
          paths = with pkgs.linuxPackages; [
            kernel.modules
            bcachefs
          ];

          postBuild = ''
            version=$(cd $out/lib/modules && ls -d *)
            ${lib.getExe' pkgs.kmod "depmod"} \
              --basedir "$out" --all "$version"
          '';
        };
      };
    };
  };
}
