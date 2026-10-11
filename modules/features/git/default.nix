{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.git = inputs.wrapper-modules.wrappers.git.wrap {
      inherit pkgs;
      settings = {
        user = {
          name = "Linus";
          email = "17277861+lnus@users.noreply.github.com";
        };
        init.defaultBranch = "main";
        diff.external = lib.getExe pkgs.difftastic;
      };
    };
  };

  flake.nixosModules.git = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.git ];
  };
}
