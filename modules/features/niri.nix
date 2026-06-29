{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.niri = {
    pkgs,
    lib,
    ...
  }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];
        input = {
          keyboard = {
            xkb = {
              layout = "us";
              options = "ctrl:nocaps";
              variant = "altgr-intl";
            };
            numlock = _: {};
          };
          mouse.accel-profile = "flat";
        };

        prefer-no-csd = _: {};
        animations.off = _: {};

        binds = {
          "Mod+Return".spawn-sh = lib.getExe pkgs.foot;
          "Mod+Q".close-window = _: {};
        };
      };
    };
  };
}
