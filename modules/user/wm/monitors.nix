{ lib, config, ... }:
let
  inherit (lib) mkOption types;
  cfg = config.modules.user.wm.monitors;
in
{
  options.modules.user.wm.monitors = mkOption {
    type = types.listOf (
      types.submodule {
        options = {
          name = mkOption {
            type = types.str;
            example = "DP-1";
          };
          primary = mkOption {
            type = types.bool;
            default = false;
          };
          width = mkOption {
            type = types.int;
            example = 1920;
          };
          height = mkOption {
            type = types.int;
            example = 1080;
          };
          refreshRate = mkOption {
            type = types.int;
            default = 60;
          };
          x = mkOption {
            type = types.int;
            default = 0;
          };
          y = mkOption {
            type = types.int;
            default = 0;
          };
          enabled = mkOption {
            type = types.bool;
            default = true;
          };
          workspace = mkOption {
            type = types.nullOr types.str;
            default = null;
          };
        };
      }
    );
    default = [ ];
  };
  config = {
    assertions = [
      {
        assertion = ((lib.length cfg) != 0) -> ((lib.length (lib.filter (m: m.primary) cfg)) == 1);
        message = "Exactly one monitor must be set to primary.";
      }
    ];
  };
}
