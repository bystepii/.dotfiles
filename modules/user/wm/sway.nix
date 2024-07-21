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
  cfg = config.modules.user.wm.swat;
  rgb = color: "rgb(${lib.removePrefix "#" color})";
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
in
{
  options.modules.user.wm.sway = {
    enable = lib.mkEnableOption "Enable Sway window manager";
    settings = lib.mkOption {
      type =
        with lib.types;
        let
          valueType =
            nullOr (oneOf [
              bool
              int
              float
              str
              path
              (attrsOf valueType)
              (listOf valueType)
            ])
            // {
              description = "Hyprland configuration value";
            };
        in
        valueType;
      default = { };
      description = ''
        Settings for the Hyprland window manager.
      '';
    };
    keyboardLayout = lib.mkOption {
      type = lib.types.str;
      default = "us";
      description = ''
        Keyboard layout for the Hyprland window manager.
      '';
    };
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration for the Hyprland window manager.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.sway = {
      enable = true;
      package = inputs.sway.packages."${systemSettings.system}".sway;
      settings = cfg.settings;
      keyboardLayout = cfg.keyboardLayout;
      extraConfig = cfg.extraConfig;
    };
  };
}
