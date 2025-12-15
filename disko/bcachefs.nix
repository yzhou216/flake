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
              type = "bcachefs";
              filesystem = "mounted_subvolumes";
              label = "group_a.root";
            };
          };
        };
      };
    };

    bcachefs_filesystems.mounted_subvolumes = {
      type = "bcachefs_filesystem";
      extraFormatArgs = [
        "--compression=zstd"
        "--background_compression=zstd"
      ];

      subvolumes = {
        "@" = {
          mountpoint = "/";
          mountOptions = [
            "verbose"
            "noatime"
            "discard"
          ];
        };

        "@nix" = {
          mountpoint = "/nix";
          mountOptions = [
            "noatime"
            "discard"
          ];
        };

        "@home" = {
          mountpoint = "/home";
          mountOptions = [
            "noatime"
            "discard"
          ];
        };

        "@home/yiyu".mountOptions = [
          "noatime"
          "discard"
        ];
      };
    };
  };
}
