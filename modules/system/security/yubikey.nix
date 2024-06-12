{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.system.security.yubikey;
in

{
  options.modules.system.security.yubikey = {
    enable = lib.mkEnableOption "Enable YubiKey support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      yubikey-personalization
      yubikey-manager
    ];

    hardware.gpgSmartcards.enable = true;

    services.udev.packages = with pkgs; [ yubikey-personalization ];

    # https://discourse.nixos.org/t/yubikey-udev-rules-and-group-permissions/34034
    services.udev.extraRules = ''
      SUBSYSTEM=="usb", ATTR{idVendor}=="1050", ATTR{idProduct}=="0407", ENV{ID_SECURITY_TOKEN}="1", GROUP="wheel"
    '';

    services.pcscd.enable = false;
  };
}
