{ config, pkgs, ... }:

{
  # enable hyprland window manager
  modules.user.wm.hyprland.enable = true;

  # enable wofi application launcher
  modules.user.wm.wofi.enable = true;
}
