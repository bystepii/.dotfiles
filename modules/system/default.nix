{
  security = import ./security;
  impermanence = import ./impermanence.nix;
  pipewire = import ./pipewire.nix;
  print = import ./print.nix;
  hyprland = import ./wm/hyprland.nix;
  greetd = import ./desktop/greetd.nix;
}
