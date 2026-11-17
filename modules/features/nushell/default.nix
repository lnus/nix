{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.nushell = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      self.packages.${pkgs.stdenv.hostPlatform.system}.nushell
      self.packages.${pkgs.stdenv.hostPlatform.system}.direnv
      carapace
      deadnix
      difftastic
      fd
      gh
      lazygit
      ripgrep
      starship
      tree
      yazi
      zoxide
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.nushell = inputs.wrapper-modules.wrappers.nushell.wrap {
      inherit pkgs;

      "config.nu" = {
        path = "${./.}/config.nu"; # whole dir, so config.nu can `use` ./scripts
      };
      "env.nu" = {
        path = ./env.nu;
      };

      env.STARSHIP_CONFIG = "${./starship.toml}";
    };
  };
}
