{
  config,
  lib,
  pkgs,
  ...
}:

let
  shellAliases = import ./aliases.nix;
in
{
  programs.bash = {
    enable = true;
    shellAliases = shellAliases;
  };

  home.packages = with pkgs; [
    bash
    bashInteractive
  ];
}
