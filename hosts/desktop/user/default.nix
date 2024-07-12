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
      workspace = "1";
    }
  ];
}
