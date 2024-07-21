{
  config,
  lib,
  pkgs,
  inputs,
  outputs,
  systemSettings,
  userSettings,
  ...
}:

{
  imports = [
    ../../../../hosts/${systemSettings.host}/system
    inputs.home-manager.nixosModules.home-manager
    ./locale.nix
    ./zsh.nix
  ] ++ (builtins.attrValues outputs.nixosModules);

  home-manager = {
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs;
      inherit outputs;
      inherit systemSettings;
      inherit userSettings;
    };
    users.${userSettings.username} = import ../../../${systemSettings.profile}/user/home.nix;
  };

  nix.package = pkgs.nixVersions.latest;
  nix.settings.experimental-features = [ "nix-command flakes" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

  # Enable networking
  networking.networkmanager.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${userSettings.username} = {
    isNormalUser = true;
    description = userSettings.name;
    shell = userSettings.shell;
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [ home-manager ];
    uid = 1000;
    hashedPasswordFile = config.sops.secrets."${userSettings.username}-password".path;
    # initialPassword = "password";
  };

  # Enable sops
  modules.system.security.sops.enable = true;

  sops.secrets."${userSettings.username}-password" = {
    sopsFile = ../../../../hosts/common/secrets.yaml;
    neededForUsers = true;
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    git
    sops
  ];

  # Set hostname
  networking.hostName = systemSettings.hostname;

  modules.system.security.ssh.enable = true;
  modules.system.security.ssh.authorizedKeys = [
    (builtins.readFile ../../../../users/${userSettings.username}/ssh.pub)
  ];
  modules.system.security.yubikey.enable = true;

  # Note: not needed as can be done with a user module
  modules.system.security.gpg.enable = true;
  modules.system.security.gpg.agent.asSshAgent = true;
}
