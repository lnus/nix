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
    # FIXME user logic
    # Make nushell the login shell and install the wrapped derivation.
    users.users.linus.shell =
      self.packages.${pkgs.stdenv.hostPlatform.system}.myNushell;

    environment.systemPackages =
      [self.packages.${pkgs.stdenv.hostPlatform.system}.myNushell]
      ++ (with pkgs; [
        zellij
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
    packages.myNushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;

      # The wrapper passes these to `nu --config` / `nu --env-config`.
      # `path` references the adjacent `.nu` files directly, so editing them
      # is just a normal file change — no escaping into a Nix string.
      "config.nu" = {path = ./config.nu;};
      "env.nu" = {path = ./env.nu;};
    };
  };
}
