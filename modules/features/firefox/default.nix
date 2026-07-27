{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages.firefox = pkgs.firefox;
  };

  flake.nixosModules.firefox = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.firefox
    ];
  };
}
