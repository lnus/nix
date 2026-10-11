{ self, inputs, ... }: {
  perSystem = { pkgs, lib, ... }: {
    packages.jujutsu = inputs.wrapper-modules.wrappers.jujutsu.wrap {
      inherit pkgs;
      settings = {
        ui = {
          default-command = "log";
          diff-formatter = [
            (lib.getExe pkgs.difftastic)
            "--color=always"
            "$left"
            "$right"
          ];
        };
        user = {
          name = "Linus";
          email = "17277861+lnus@users.noreply.github.com";
        };
      };
    };
  };

  flake.nixosModules.jujutsu = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.jujutsu ];
  };
}
