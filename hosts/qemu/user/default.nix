{
  config,
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  modules.user.wm.hyprland = {
    # settings = {
    #   cursor = {
    #     no_hardware_cursors = true;
    #   };
    # };
    extraConfig = ''
      env = WLR_RENDERER_ALLOW_SOFTWARE,1
      env = WLR_NO_HARDWARE_CURSORS,1 # deprecated
    '';
  };
  # Doesn't work
  # home.sessionVariables = {
  #   WLR_RENDERER_ALLOW_SOFTWARE = 1;
  #   WLR_NO_HARDWARE_CURSORS = 1;
  # };
  modules.user.wm.monitors = [
    {
      name = "Virtual-1";
      primary = true;
      width = 1920;
      height = 1080;
      workspace = "1";
    }
  ];
}
