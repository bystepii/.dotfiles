{ config, pkgs, ... }:

let
  fonts = config.modules.user.wm.fonts.monospace;
in
{
  programs.kitty = {
    enable = true;
    font = {
      inherit (fonts) size;
      name = fonts.family;
    };
    keybindings = {
      "ctrl+left" = "neighboring_window left";
      "ctrl+right" = "neighboring_window right";
      "ctrl+up" = "neighboring_window up";
      "ctrl+down" = "neighboring_window down";
      "ctrl+shift+enter" = "new_window_with_cwd";
      "ctrl+shift+t" = "new_tab_with_cwd";
    };
    settings = {
      enable_audio_bell = false;
      disable_ligatures = "never";
      url_style = "curly";
      detect_urls = true;
      cursor_shape = "beam";
      cursor_beam_thickness = "1.8";
      mouse_hide_wait = "3.0";
      repaint_delay = 10;
      input_delay = 3;
      sync_to_monitor = true;
      tab_bar_style = "powerline";
      background_opacity = "0.9";
      # shell = # TODO: add shell
      shell_integration = "no-sudo";
    };
  };
}
