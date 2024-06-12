{
  config,
  lib,
  pkgs,
  ...
}:

{
  programs.bash = {
    enable = true;
  };

  home.packages = with pkgs; [
    bash
    bashInteractive
  ];
}
