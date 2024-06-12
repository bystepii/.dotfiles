{ inputs, ... }:
{
  imports = [
    ./gpg.nix
    ./ssh.nix
    ./yubikey.nix
    ./sops.nix
  ];
}
