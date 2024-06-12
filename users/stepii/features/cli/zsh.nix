{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    shellAliases = {
      ll = "ls -l";
      la = "ls -a";
      l = "ls";
      lla = "ls -la";
      ".." = "cd ..";
    };
  };

  home.packages = with pkgs; [ zsh ];
}
