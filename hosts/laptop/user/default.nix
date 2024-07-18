{
  config,
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  modules.user.wm.monitors = [
    {
      name = "eDP-1";
      primary = true;
      width = 1920;
      height = 1080;
      refreshRate = 144;
      workspace = "1";
    }
  ];
}
