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
  cfg = config.modules.user.wm.hyprland;
in
{
  options.modules.user.wm.hyprland = {
    enable = lib.mkEnableOption "Enable Hyprland window manager";
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
    extraConfig = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = ''
        Extra configuration for the Hyprland window manager.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = cfg.settings // {
        monitor =
          let
            waybarSpace =
              let
                inherit (config.wayland.windowManager.hyprland.settings.general) gaps_in gaps_out;
                inherit (config.programs.waybar.settings.primary) position height width;
                gap = gaps_out - gaps_in;
              in
              {
                top = if (position == "top") then height + gap else 0;
                bottom = if (position == "bottom") then height + gap else 0;
                left = if (position == "left") then width + gap else 0;
                right = if (position == "right") then width + gap else 0;
              };
          in
          [
            # ",addreserved,${toString waybarSpace.top},${toString waybarSpace.bottom},${toString waybarSpace.left},${toString waybarSpace.right}"
          ]
          ++ (map (
            m:
            "${m.name},${
              if m.enabled then
                "${toString m.width}x${toString m.height}@${toString m.refreshRate},${toString m.x}x${toString m.y},1"
              else
                "disable"
            }"
          ) (config.modules.user.wm.monitors));

        workspace = map (m: "name:${m.workspace},monitor:${m.name}") (
          lib.filter (m: m.enabled && m.workspace != null) config.modules.user.wm.monitors
        );
      };
      extraConfig = cfg.extraConfig;
    };
  };
}
