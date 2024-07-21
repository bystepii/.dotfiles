{
  config,
  lib,
  pkgs,
  systemSettings,
  ...
}:

let
  cfg = config.modules.system.desktop.sddm;
in
{
  options.modules.system.desktop.sddm = {
    enable = lib.mkEnableOption "Enable the SDDM login manager";
  };

  config = lib.mkIf cfg.enable {
    services = {
      xserver = {
        enable = true;
        xkb = {
          layout = systemSettings.keyboardLayout;
        };
      };
      displayManager.sddm = {
        enable = true;
        wayland.enable = true;
        enableHidpi = true;
        package = pkgs.sddm;
      };
    };
  };
}
