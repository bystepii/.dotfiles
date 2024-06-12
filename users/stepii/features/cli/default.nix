{ config, pkgs, ... }:

{
  imports = [
    ./bash.nix
    ./git.nix
    ./gpg.nix
    ./zsh.nix
  ];

  home.packages = with pkgs; [ nixd ];
}
