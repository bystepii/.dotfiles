{
  inputs,
  lib,
  config,
  userSettings,
  ...
}:
let
  cfg = config.modules.system.wm;
in
{
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  config.modules.system.wm.hyprland = lib.mkIf (userSettings.wm == "hyprland") { enable = true; };
  # cs.gnome = lib.mkIf (cu == "gnome") { enable = true; };
  # cs.sway = lib.mkIf (cu == "sway") { enable = true; }; 
}
