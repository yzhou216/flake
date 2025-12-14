{ lib, ... }:
{
  disko.devices = {
    disk.disk1 = {
      device = lib.mkDefault "/dev/nvme0n1";
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          ESP = {
            name = "ESP";
            size = "512M";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              mountpoint = "/boot";
            };
          };
          plainSwap = {
            size = "32G";
            content = {
              type = "swap";
              discardPolicy = "both";
              resumeDevice = true;
            };
          };
          root = {
            name = "root";
            size = "100%";
            content = {
              type = "filesystem";
              format = "bcachefs";
              mountOptions = [
                "noatime"
                "compression=zstd"
                "background_compression=zstd"
                "discard"
              ];
              mountpoint = "/";
              # TODO: subvolumes not yet supported by disko
              # subvolumes = {
              #   "/home" = {};
              #   "/nix" = {};
              # };
            };
          };
        };
      };
    };
  };
}
