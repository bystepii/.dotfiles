{
  config,
  lib,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  # environment.shells = [ pkgs.zsh ];
  # users.defaultUserShell = pkgs.zsh;
  programs.zsh.enable = true;
}
