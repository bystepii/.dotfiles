{
  inputs,
  lib,
  config,
  userSettings,
  ...
}:
{
  imports = [
    ./hyprland.nix
    ./waybar.nix
    ./monitors.nix
  ];

  config.modules.user.wm.hyprland = lib.mkIf (userSettings.wm == "hyprland") { enable = true; };
  # cfg.sway = lib.mkIf (cfg == "sway") { enable = true; };
  # cfg.gnome = lib.mkIf (cfg == "gnome") { enable = true; };
}
