{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages.vesktop = pkgs.vesktop;
  };

  flake.nixosModules.vesktop = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.vesktop
    ];
  };
}
