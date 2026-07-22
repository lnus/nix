{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.nushell = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nushell
      carapace
      difftastic
      direnv
      fd
      gh
      jujutsu
      ripgrep
      starship
      tree
      yazi
      zoxide
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;

      "config.nu" = {path = ./config.nu;};
      "env.nu" = {path = ./env.nu;};
    };
  };
}
