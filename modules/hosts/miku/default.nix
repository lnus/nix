{
  self,
  inputs,
  ...
}: {
  flake.nixosConfigurations.miku = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.mikuConfiguration
    ];
  };
}
