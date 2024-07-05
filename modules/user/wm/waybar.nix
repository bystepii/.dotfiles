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
  cfg = config.modules.user.wm.waybar;
in
{
  options.modules.user.wm.waybar = {
    enable = lib.mkEnableOption "Enable Waybar status bar";
  };

  config = lib.mkIf cfg.enable {
    programs.waybar = {
      enable = true;
    };
  };
}
