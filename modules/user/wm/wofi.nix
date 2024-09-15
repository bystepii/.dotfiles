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
  cfg = config.modules.user.wm.wofi;
in
{
  options.modules.user.wm.wofi = {
    enable = lib.mkEnableOption "Enable Wofi application launcher";
  };

  config = lib.mkIf cfg.enable {
    programs.wofi = {
      enable = true;
      package = pkgs.wofi;
    };
  };
}