{
  pkgs,
  lib,
  inputs,
  config,
  userSettings,
  ...
}:
let
  cfg = config.modules.user.impermanence;
in
{

  imports = [ inputs.impermanence.nixosModules.home-manager.impermanence ];

  options.modules.user.impermanence = {
    data.directories = lib.mkOption {
      default = [ ];
      description = '''';
    };
    data.files = lib.mkOption {
      default = [ ];
      description = '''';
    };
    cache.directories = lib.mkOption {
      default = [ ];
      description = '''';
    };
    cache.files = lib.mkOption {
      default = [ ];
      description = '''';
    };
  };

  config = {
    home.persistence = {
      "/persist/home/${userSettings.username}/data" = {
        directories = [
          "Downloads"
          "Music"
          "Pictures"
          "Projects"
          "Documents"
          "Videos"
          "VirtualBox VMs"
          # ".gnupg"
          ".ssh"
          ".nixops"
          ".dotfiles"

          "nixconf"
        ] ++ cfg.data.directories;
        files = [ ] ++ cfg.data.files;
        allowOther = true;
      };
      "/persist/home/${userSettings.username}/cache" = {
        directories = [
          ".config/dconf"
          ".local/share/keyrings"
          ".local/share/direnv"
        ] ++ cfg.cache.directories;
        files = [ ] ++ cfg.cache.files;
        allowOther = true;
      };
    };
  };
}
