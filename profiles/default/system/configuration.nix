{
  config,
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  imports = [ ../../common/system/global ];

  # Enable impermanence
  modules.system.impermanence.enable = true;

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable printing support.
  modules.system.printing.enable = true;

  # Enable sound.
  modules.system.pipewire.enable = true;

  # Enable Hyprland window manager.
  modules.system.wm.hyprland.enable = true;

  # Enable the greetd login manager.
  modules.system.desktop.greetd.enable = true;

  # Enable the SDDM login manager.
  # modules.system.desktop.sddm.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # List services that you want to enable:

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
}
