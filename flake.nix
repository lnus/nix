{
  description = "wow";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...
  } @ inputs: let
    mkHost = hostname:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # FIX: take from attrset
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/${hostname}

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users.linus = import ./home.nix;
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      nixvm = mkHost "nixvm";
    };
  };
}
