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
  cfg = config.modules.system.nvidia;
in
{
  options.modules.system.nvidia = {
    enable = lib.mkEnableOption "Enable NVIDIA drivers";
  };

  config = lib.mkIf cfg.enable {
    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.nvidia = {
      modesetting.enable = true;
      powerManagement.enable = true;
      open = false;
      nvidiaSettings = true;
      prime.offload.enable = false;
    };
  };
}
