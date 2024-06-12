{
  config,
  lib,
  pkgs,
  inputs,
  systemSettings,
  userSettings,
  outputs,
  ...
}:

let
  cfg = config.modules.system.impermanence;
in
{
  imports = [ inputs.impermanence.nixosModules.impermanence ];

  options.modules.system.impermanence = {
    enable = lib.mkEnableOption "Destroy the root on every boot";

    volumeGroup = lib.mkOption {
      default = "root_vg";
      description = ''
        Btrfs volume group name
      '';
    };

    directories = lib.mkOption {
      default = [ ];
      description = ''
        directories to persist
      '';
    };

    files = lib.mkOption {
      default = [ ];
      description = ''
        files to persist
      '';
    };
  };

  config = {
    fileSystems."/persist".neededForBoot = true;
    programs.fuse.userAllowOther = true;
    users.mutableUsers = lib.mkIf cfg.enable false;

    # Create directories for user data persistence
    systemd.tmpfiles.rules = [
      "d /persist/home 0755 root root"
      "d /persist/home/${userSettings.username} 0700 ${userSettings.username} users"
      "d /persist/home/${userSettings.username}/data 0700 ${userSettings.username} users"
      "d /persist/home/${userSettings.username}/cache 0700 ${userSettings.username} users"
    ];

    environment.persistence."/persist/system" = {
      hideMounts = true;
      directories = [
        "/etc/nixos"
        "/var/log"
        "/var/lib/bluetooth"
        "/var/lib/nixos"
        "/var/lib/systemd/coredump"
        "/etc/NetworkManager/system-connections"
        {
          directory = "/var/lib/colord";
          user = "colord";
          group = "colord";
          mode = "u=rwx,g=rx,o=";
        }
      ] ++ cfg.directories;
      files = [
        "/etc/machine-id"
        {
          file = "/var/keys/secret_file";
          parentDirectory = {
            mode = "u=rwx,g=,o=";
          };
        }
        "/etc/ssh/ssh_host_ed25519_key"
        "/etc/ssh/ssh_host_ed25519_key.pub"
        "/etc/ssh/ssh_host_rsa_key"
        "/etc/ssh/ssh_host_rsa_key.pub"
      ] ++ cfg.files;
    };

    boot.initrd.postMountCommands = lib.mkIf cfg.enable (
      lib.mkAfter ''
        mkdir /btrfs_tmp
        mount /dev/${cfg.volumeGroup}/root /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      ''
    );
  };
}
