{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.user.apps.browser;
in
{
  options.modules.user.apps.browser = {
    enable = lib.mkEnableOption "Enable browser application";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.brave;
      description = "Package for browser application";
      example = "pkgs.brave";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.chromium = {
      enable = true;
      package = cfg.package;
    };
  };
}
