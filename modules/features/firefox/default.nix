{ self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.firefox = pkgs.firefox;
  };

  flake.nixosModules.firefox =
    {
      options,
      lib,
      pkgs,
      ...
    }:
    let
      firefox = self.packages.${pkgs.stdenv.hostPlatform.system}.firefox;
    in
    {
      config = lib.mkMerge [
        { environment.systemPackages = [ firefox ]; }

        (lib.optionalAttrs (options.programs.niri ? wrapper) {
          programs.niri.wrapper.binds."Mod+B" = _: {
            props.hotkey-overlay-title = "Firefox";
            content.spawn = [ (lib.getExe firefox) ];
          };
        })
      ];
    };
}
