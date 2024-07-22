{
  config,
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  # +------+ +------+
  # | DP-2 | | DP-1 |
  # +------+ +------+
  modules.user.wm.monitors = [
    {
      name = "DP-2";
      primary = true;
      width = 2560;
      height = 1440;
      refreshRate = 165;
      workspace = "1";
    }
    {
      name = "DP-1";
      width = 2560;
      height = 1440;
      x = 2560;
      refreshRate = 165;
      workspace = "2";
    }
  ];
}
