{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.user.security.gpg;
  opt = {
    options = {
      text = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        description = ''
          Text of an OpenPGP public key.
        '';
      };

      source = lib.mkOption {
        type = lib.types.path;
        description = ''
          Path of an OpenPGP public key file.
        '';
      };

      trust = lib.mkOption {
        type = lib.types.nullOr (
          lib.types.enum [
            "unknown"
            1
            "never"
            2
            "marginal"
            3
            "full"
            4
            "ultimate"
            5
          ]
        );
        default = null;
        description = ''
          Trust level of the key.
        '';
      };
    };
  };
in
{
  options.modules.user.security.gpg = {
    enable = lib.mkEnableOption "Enable gpg";
    keys = lib.mkOption {
      type = lib.types.listOf (lib.types.submodule opt);
      default = [ ];
      description = "List of gpg public keys to add to the gpg keyring";
    };
  };

  config = lib.mkIf cfg.enable {
    # home.packages = with pkgs; [ gnupg ];

    # services.gpg-agent = {
    #   enable = true;
    #   enableSshSupport = true;
    #   enableExtraSocket = true;
    # };

    programs.gpg = {
      enable = true;
      publicKeys = cfg.keys;
    };
  };
}
