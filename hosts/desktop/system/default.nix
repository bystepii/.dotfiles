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
    { _module.args.device = "/dev/sda"; }
    inputs.hardware.nixosModules.common-cpu-amd
    inputs.hardware.nixosModules.common-gpu-nvidia
    inputs.hardware.nixosModules.common-pc-ssd
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.timeout = 1;

  # Enable systemd stage 1
  boot.initrd.systemd.enable = true;

  # Enable nvidia drivers
  modules.system.nvidia.enable = true;
}
