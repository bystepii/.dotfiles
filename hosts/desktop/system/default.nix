{
  config,
  pkgs,
  inputs,
  systemSettings,
  ...
}:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    inputs.disko.nixosModules.disko
    ./disko.nix
    { _module.args.disk = "/dev/vda"; }
  ];
}
