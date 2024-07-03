{
  description = "NixOS flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-24.05";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-stable.url = "github:nix-community/home-manager/release-24.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";
    systems.url = "github:nix-systems/default-linux";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    impermanence.url = "github:bystepii/impermanence";
    sops-nix = {
      url = "github:mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };
    hyprland = {
      type = "git";
      url = "https://github.com/hyprwm/Hyprland";
      submodules = true;
    };
    hyprland.inputs.nixpkgs.follows = "nixpkgs";
    hyprland-plugins.url = "github:hyprwm/hyprland-plugins";
    hyprland-plugins.inputs.hyprland.follows = "hyprland";
  };

  outputs =
    { self, ... }@inputs:
    let
      inherit (self) outputs;
      systemSettings = {
        system = "x86_64-linux";
        # host is the name of the machine (see hosts/ directory)
        host = "qemu";
        # profile is the name of the configuration (see profiles/ directory)
        profile = "default";
        # hostname is the actual hostname that will be set
        hostname = "nixos";
        timeZone = "Europe/Madrid";
        defaultLocale = "en_US.UTF-8";
        extraLocale = "es_ES.UTF-8";
        keyboardLayout = "es";
        unstable = true;
      };
      userSettings = {
        # user is the name of the user configuration (see users/ directory)
        user = "stepii";
        # username is the actual name of the user that will be created
        username = "stepii";
        name = "Stepan";
        email = "stepanstepan0000@gmail.com";
        dotfilesDir = "~/.dotfiles";
        shell = pkgs.zsh;
      };
      pkgs = (
        if systemSettings.unstable then
          (import inputs.nixpkgs {
            system = systemSettings.system;
            config = {
              allowUnfree = true;
              allowUnfreePredicate = (_: true);
            };
          })
        else
          pkgs-stable
      );
      pkgs-stable = (
        import inputs.nixpkgs-stable {
          system = systemSettings.system;
          config = {
            allowUnfree = true;
            allowUnfreePredicate = (_: true);
          };
        }
      );
      home-manager = (
        if systemSettings.unstable then inputs.home-manager else inputs.home-manager-stable
      );
      lib =
        (if systemSettings.unstable then inputs.nixpkgs.lib else inputs.nixpkgs-stable.lib)
        // home-manager.lib;
      forEachSystem = f: lib.genAttrs (import inputs.systems) (system: f pkgsFor.${system});
      pkgsFor = lib.genAttrs (import inputs.systems) (
        system:
        import inputs.nixpkgs {
          inherit system;
          config.allowUnfree = true;
        }
      );
    in
    {
      nixosModules = import ./modules/system;
      homeManagerModules = import ./modules/user;

      overlays = import ./overlays { inherit inputs outputs; };

      packages = forEachSystem (pkgs: import ./pkgs { inherit pkgs; });

      nixosConfigurations = {
        ${systemSettings.hostname} = lib.nixosSystem {
          specialArgs = {
            inherit inputs;
            inherit outputs;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [ ./profiles/${systemSettings.profile}/system/configuration.nix ];
        };
      };
      homeConfigurations = {
        ${userSettings.username} = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          extraSpecialArgs = {
            inherit inputs;
            inherit outputs;
            inherit systemSettings;
            inherit userSettings;
          };
          modules = [ ./profiles/${systemSettings.profile}/user/home.nix ];
        };
      };
    };
}
