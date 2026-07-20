{self, ...}: {
  flake.nixosModules.coreUser = {
    pkgs,
    ...
  }: {
    imports = [self.nixosModules.nushell];

    users.users.linus = {
      initialPassword = "password";
      isNormalUser = true;
      description = "linus";
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.nushell;
    };

    environment.variables.EDITOR = "hx";
    environment.variables.VISUAL = "hx";

    environment.sessionVariables.GTK_THEME = "Adwaita:dark";
  };
}