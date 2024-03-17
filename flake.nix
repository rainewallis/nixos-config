{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-colors = {
      url = "github:misterio77/nix-colors";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, home-manager, nix-colors, stylix, ... }@inputs: 
  let
    options = builtins.fromTOML (builtins.readFile (./. + "/options.toml"));
    raine = {
      user.settings = {
        username = "raine";
        forename = "Raine";
        surname = "Wallis";
      };
      system.settings = {
        arch = "x86_64-linux";
        displays = options.displays.names;
      };
    }; 
  in
  {
    nixosConfigurations.rainew-nix = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;

          home-manager.users.${raine.user.settings.username} = import ./home.nix;
          home-manager.extraSpecialArgs = {
            inherit raine;
            inherit nix-colors;
            inherit stylix;
          };
        }
      ];
      specialArgs = {
        inherit raine;
      };
    };
  };
}
