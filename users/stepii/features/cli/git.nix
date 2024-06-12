{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
  };

  home.file.".gitconfig".source = ../../.gitconfig;

  home.packages = with pkgs; [ git ];
}
