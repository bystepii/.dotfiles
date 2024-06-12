{ config, pkgs, ... }:

let
  gpgKey = pkgs.fetchurl {
    # url = "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x1cf624dc518e0bf24858564e2c352f90b4c35a85";
    # sha256 = "1a3p9518610rpg5m1sg5qhdhk5789fk6f1prnm4a5shyf16mwx4c";
    url = "https://keys.openpgp.org/vks/v1/by-fingerprint/1CF624DC518E0BF24858564E2C352F90B4C35A85";
    sha256 = "0vqcb9gwm38m4jhly0gclh21n02khppn1rgs12lnn68bznfz6ijw";
  };
in
{
  modules.user.security.gpg.enable = true;
  modules.user.security.gpg.keys = [
    {
      source = "${gpgKey}";
      trust = 5;
    }
  ];

  home.packages = with pkgs; [ gnupg ];
}
