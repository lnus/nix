{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nushell = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nushell
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;

      "config.nu" = {path = ./config.nu;};
    };
  };
}
