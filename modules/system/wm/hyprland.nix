{
  config,
  lib,
  pkgs,
  inputs,
  systemSettings,
  userSettings,
  outputs,
  ...
}:

let
  cfg = config.modules.system.wm.hyprland;
in
{
  options.modules.system.wm.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland window manager";
  };

  config = lib.mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      package = inputs.hyprland.packages."${systemSettings.system}".hyprland;
    };
  };
}
