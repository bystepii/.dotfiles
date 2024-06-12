{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:

let
  cfg = config.modules.system.security.ssh;
  hasOptinPersistence = config.modules.system.impermanence.enable;
in
{
  options.modules.system.security.ssh = {
    enable = lib.mkEnableOption "Enable the OpenSSH module";
    authorizedKeys = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of ssh public keys to add to the authorized_keys file";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable the OpenSSH daemon.
    services.openssh = {
      enable = true;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        ChallengeResponseAuthentication = false;
        KbdInteractiveAuthentication = false;
      };

      hostKeys = [
        {
          path = "${lib.optionalString hasOptinPersistence "/persist"}/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
    };

    # Add authorized keys to the authorized_keys file.
    users.users.${userSettings.username}.openssh.authorizedKeys.keys = cfg.authorizedKeys;
  };
}
