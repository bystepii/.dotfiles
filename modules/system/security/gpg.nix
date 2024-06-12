{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.security.gpg;
in
{
  # Note: not needed as can be done with a user module.

  options.modules.system.security.gpg = {
    enable = lib.mkEnableOption "Enable the GnuPG module";
    agent.asSshAgent = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use GnuPG agent as SSH agent";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ gnupg ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
      pinentryPackage = pkgs.pinentry-tty;
    };

    environment.shellInit = lib.mkIf cfg.agent.asSshAgent ''
      gpg-connect-agent /bye
      export SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)
    '';

    # Disable the OpenSSH agent if GnuPG is enabled and configured to act as an SSH agent.
    programs.ssh.startAgent = lib.mkIf cfg.agent.asSshAgent false;
  };
}
