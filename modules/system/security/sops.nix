{
  config,
  lib,
  pkgs,
  inputs,
  userSettings,
  ...
}:

let
  cfg = config.modules.system.security.sops;
  isEd25519 = k: k.type == "ed25519";
  keys = builtins.filter isEd25519 config.services.openssh.hostKeys;
  getKeyPath = k: k.path;
in
{
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.modules.system.security.sops = {
    enable = lib.mkEnableOption "Enable the SOPS module";
  };

  config = lib.mkIf cfg.enable {
      sops.age.sshKeyPaths = map getKeyPath keys;
  };
}
