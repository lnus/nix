{ self, ... }: {
  flake.nixosModules.coreUser =
    {
      pkgs,
      ...
    }:
    {
      imports = [ self.nixosModules.nushell ];

      users.users.linus = {
        initialPassword = "password";
        isNormalUser = true;
        extraGroups = [ "wheel" ];
        description = "linus";
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.nushell;
      };

      # pkexec (e.g. greeter sync) rejects a $SHELL that isn't listed here
      environment.shells = [ self.packages.${pkgs.stdenv.hostPlatform.system}.nushell ];

      security.sudo.enable = true;

      environment.variables.EDITOR = "hx";
      environment.variables.VISUAL = "hx";
    };
}
