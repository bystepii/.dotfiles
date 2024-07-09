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
  rgb = color: "rgb(${lib.removePrefix "#" color})";
  rgba = color: alpha: "rgba(${lib.removePrefix "#" color}${alpha})";
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
    wayland.windowManager.hyprland = {
      enable = true;
      settings = cfg.settings // {
        #####################
        ### LOOK AND FEEL ###
        #####################

        # Refer to https://wiki.hyprland.org/Configuring/Variables/

        # https://wiki.hyprland.org/Configuring/Variables/#general
        general = {
          gaps_in = 5;
          gaps_out = 20;

          border_size = 2;

          # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
          # col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
          # col.inactive_border = rgba(595959aa)

          # Set to true enable resizing windows by clicking and dragging on borders and gaps
          resize_on_border = false;

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;

          layout = "dwindle";
        };

        # https://wiki.hyprland.org/Configuring/Variables/#decoration
        decoration = {
          rounding = 10;

          # Change transparency of focused and unfocused windows
          active_opacity = 1.0;
          inactive_opacity = 1.0;

          drop_shadow = true;
          shadow_range = 4;
          shadow_render_power = 3;
          # col.shadow = rgba(1a1a1aee)

          # https://wiki.hyprland.org/Configuring/Variables/#blur
          blur = {
            enabled = true;
            size = 3;
            passes = 1;

            vibrancy = 0.1696;
          };
        };

        # https://wiki.hyprland.org/Configuring/Variables/#animations
        animations = {
          enabled = true;

          # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        dwindle = {
          pseudotile = true; # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # You probably want this
        };

        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        # master = {
        #   new_status = "master";
        # };

        # https://wiki.hyprland.org/Configuring/Variables/#misc
        misc = {
          force_default_wallpaper = -1; # Set to 0 or 1 to disable the anime mascot wallpapers
          disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
        };

        #############
        ### INPUT ###
        #############

        # https://wiki.hyprland.org/Configuring/Variables/#input
        input = {
          kb_layout = cfg.keyboardLayout;
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = 1;

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.

          touchpad = {
            natural_scroll = false;
          };
        };

        ################
        ### MONITORS ###
        ################

        # See https://wiki.hyprland.org/Configuring/Monitors/
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
      extraConfig =
        cfg.extraConfig
        #############################
        ### ENVIRONMENT VARIABLES ###
        #############################

        # See https://wiki.hyprland.org/Configuring/Environment-variables/
        + ''
          env = XCURSOR_SIZE,24
          env = HYPRCURSOR_SIZE,24
        '';
    };
  };
}
