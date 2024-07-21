{
  security = import ./security;
  impermanence = import ./impermanence.nix;
  pipewire = import ./pipewire.nix;
  print = import ./print.nix;
  wm = import ./wm;
  desktop = import ./desktop;
  nvidia = import ./nvidia.nix;
}
