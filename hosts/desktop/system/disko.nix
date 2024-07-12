{
  device ? throw "Set this to your disk device, e.g. /dev/sda",
  ...
}:
{
  disko.devices = {
    disk.main = {
      inherit device;
      type = "disk";
      content = {
        type = "gpt";
        partitions = {
          boot = {
            name = "boot";
            label = "BOOT";
            size = "1M";
            type = "EF02";
          };
          esp = {
            name = "ESP";
            label = "ESP";
            size = "1G";
            type = "EF00";
            content = {
              type = "filesystem";
              format = "vfat";
              extraArgs = [ "-n ESP" ];
              mountOptions = [ "umask=0077" ];
              mountpoint = "/boot";
            };
          };
          swap = {
            name = "swap";
            size = "64G";
            label = "SWAP";
            content = {
              type = "swap";
              extraArgs = [ "-L SWAP" ];
              resumeDevice = true;
            };
          };
          root = {
            name = "root";
            label = "ROOT";
            size = "100%";
            content = {
              type = "lvm_pv";
              vg = "root_vg";
            };
          };
        };
      };
    };
    lvm_vg = {
      root_vg = {
        type = "lvm_vg";
        lvs = {
          root = {
            name = "root";
            size = "100%FREE";
            # label = "ROOT";
            content = {
              type = "btrfs";
              extraArgs = [
                "-f"
                "-L ROOT"
              ];

              subvolumes = {
                "/root" = {
                  mountOptions = [
                    "compress=zstd"
                    "subvol=root"
                    "noatime"
                  ];
                  mountpoint = "/";
                };

                "/persist" = {
                  mountOptions = [
                    "compress=zstd"
                    "subvol=persist"
                    "noatime"
                  ];
                  mountpoint = "/persist";
                };

                "/nix" = {
                  mountOptions = [
                    "compress=zstd"
                    "subvol=nix"
                    "noatime"
                  ];
                  mountpoint = "/nix";
                };
              };
            };
          };
        };
      };
    };
  };
}
