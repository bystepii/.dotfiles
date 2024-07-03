{
  config,
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  modules.user.wm.hyprland.extraConfig = ''
    env = WLR_RENDERER_ALLOW_SOFTWARE,1
    env = WLR_NO_HARDWARE_CURSORS,1
  '';
  # Doesn't work
  # home.sessionVariables = {
  #   WLR_RENDERER_ALLOW_SOFTWARE = 1;
  #   WLR_NO_HARDWARE_CURSORS = 1;
  # };
}
