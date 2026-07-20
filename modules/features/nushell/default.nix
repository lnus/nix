{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nushell = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages =
      [self.packages.${pkgs.stdenv.hostPlatform.system}.nushell]
      ++ (with pkgs; [
        yazi
        zoxide
        carapace
        direnv
        ripgrep
        fd
        jujutsu
        difftastic
        tree
        gh
      ]);
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;

      "config.nu" = {path = ./config.nu;};
    };
  };
}
