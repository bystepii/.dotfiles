{
  config,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    ../../common/user/global
    ../../../users/${userSettings.username}/features/desktop/wm/hyprland.nix
  ];

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/stepii/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  modules.user.wm.hyprland.keyboardLayout = systemSettings.keyboardLayout;

  # Enable the waybar status bar.
  modules.user.wm.waybar.enable = true;

}
