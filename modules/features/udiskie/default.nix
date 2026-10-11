{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.udiskie = inputs.wrapper-modules.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.udiskie;
      flags = {
        "--automount" = true;
        "--notify" = true;
        "--smart-tray" = true;
      };
    };
  };

  flake.nixosModules.udiskie =
    { pkgs, lib, ... }:
    let
      udiskie = self.packages.${pkgs.stdenv.hostPlatform.system}.udiskie;
    in
    {
      services.udisks2.enable = true;
      environment.systemPackages = [ udiskie ];

      systemd.user.services.udiskie = {
        description = "udiskie automounter";
        wantedBy = [ "graphical-session.target" ];
        partOf = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig.ExecStart = lib.getExe udiskie;
      };
    };
}
