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
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.niri;
    };
  };

  perSystem = {
    pkgs,
    lib,
    self',
    ...
  }: {
    packages.niri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.noctalia)
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
