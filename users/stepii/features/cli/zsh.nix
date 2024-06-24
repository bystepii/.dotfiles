{ config, pkgs, ... }:
let
  shellAliases = import ./aliases.nix;
in
{
  programs.zsh = {
    enable = true;
    shellAliases = shellAliases;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    oh-my-zsh = {
      enable = true;
      # theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "git"
        "sudo"
      ];
    };
    plugins = [
      # {
      #   name = "zsh-autosuggestions";
      #   src = pkgs.zsh-autosuggestions;
      #   file = "share/zsh-autosuggestions/zsh-autosuggestions.zsh";
      # }
      # {
      #   name = "zsh-syntax-highlighting";
      #   src = pkgs.zsh-syntax-highlighting;
      #   file = "share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh";
      # }
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];
    initExtra = "source ~/.p10k.zsh";
  };

  home.file.".p10k.zsh".source = ../../.p10k.zsh;

  home.packages = with pkgs; [ zsh ];
}
