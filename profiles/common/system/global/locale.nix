{
  config,
  lib,
  pkgs,
  systemSettings,
  userSettings,
  ...
}:

{
  # Set your time zone.
  time.timeZone = systemSettings.timeZone;

  # Select internationalisation properties.
  i18n = {
    defaultLocale = systemSettings.defaultLocale;

    extraLocaleSettings = {
      LC_ADDRESS = systemSettings.extraLocale;
      LC_IDENTIFICATION = systemSettings.extraLocale;
      LC_MEASUREMENT = systemSettings.extraLocale;
      LC_MONETARY = systemSettings.extraLocale;
      LC_NAME = systemSettings.extraLocale;
      LC_NUMERIC = systemSettings.extraLocale;
      LC_PAPER = systemSettings.extraLocale;
      LC_TELEPHONE = systemSettings.extraLocale;
      LC_TIME = systemSettings.extraLocale;
    };

    supportedLocales = [
      "${systemSettings.defaultLocale}/UTF-8"
      "${systemSettings.extraLocale}/UTF-8"
    ];
  };

  # Configure console keymap
  console.keyMap = systemSettings.keyboardLayout;
}
