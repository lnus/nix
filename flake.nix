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
    inherit (nixpkgs) lib;

    mkHost = {
      hostname,
      system ? "x86_64-linux",
      users ? ["linus"],
    }:
      nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/${hostname}
          ./hosts/common

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              extraSpecialArgs = {inherit inputs;};
              users = lib.genAttrs users (user: import ./home/${user});
            };
          }
        ];
      };
  in {
    nixosConfigurations = {
      nixvm = mkHost {hostname = "nixvm";};
    };
  };
}
