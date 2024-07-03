{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.desktop.greetd;

  sway-kiosk =
    command:
    "${lib.getExe pkgs.sway} --unsupported-gpu --config ${pkgs.writeText "kiosk.config" ''
      output * bg #000000 solid_color
      xwayland disable
      input "type:touchpad" {
        tap enabled
      }
      exec '${command}; ${pkgs.sway}/bin/swaymsg exit'
    ''}";
in
{
  options.modules.system.desktop.greetd = {
    enable = lib.mkEnableOption "Enable the greetd login manager";
  };

  config = lib.mkIf cfg.enable {
    programs.regreet = {
      enable = true;
    };
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = sway-kiosk (lib.getExe config.programs.regreet.package);
        };
      };
    };
  };
}
