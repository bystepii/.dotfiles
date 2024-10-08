{
  config,
  lib,
  ...
}:

let
  mkFontOption = kind: {
    family = lib.mkOption {
      type = lib.types.str;
      default = null;
      description = "Family name for ${kind} font profile";
      example = "Fira Code";
    };
    package = lib.mkOption {
      type = lib.types.package;
      default = null;
      description = "Package for ${kind} font profile";
      example = "pkgs.fira-code";
    };
    size = lib.mkOption {
      type = lib.types.int;
      default = 12;
      description = "Size in pixels for ${kind} font profile";
      example = "12";
    };
  };
  cfg = config.modules.user.wm.fonts;
in
{
  options.modules.user.wm.fonts = {
    enable = lib.mkEnableOption "Enable fonts profiles";
    monospace = mkFontOption "monospace";
    regular = mkFontOption "regular";
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = true;
    home.packages = [
      cfg.monospace.package
      cfg.regular.package
    ];
  };
}
