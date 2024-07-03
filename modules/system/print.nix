{
  config,
  lib,
  options,
  pkgs,
  ...
}:

let
  options = options.modules.system.printing;
in
{
  options.modules.system.printing = {
    enable = lib.mkEnableOption "Enable printing support";
  };

  config = lib.mkIf config.modules.system.printing.enable {
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
    };
  };
}
