{ self, ... }: {
  perSystem = { pkgs, ... }: {
    packages.boltLauncher = pkgs.symlinkJoin {
      name = "bolt-launcher-wrapped";
      paths = [ pkgs.bolt-launcher ];
      buildInputs = [ pkgs.makeWrapper ];
      postBuild = ''
        wrapProgram $out/bin/bolt-launcher \
          --set TZ ":${self.timezone}" \
          --run 'export XRE_PROFILE_PATH="$HOME/.config/mozilla/firefox/$USER"' \
          --set _JAVA_AWT_WM_NONREPARENTING 1
      '';
    };
  };

  flake.nixosModules.boltLauncher =
    {
      options,
      lib,
      pkgs,
      ...
    }:
    {
      config = lib.mkMerge [
        {
          environment.systemPackages = [
            self.packages.${pkgs.stdenv.hostPlatform.system}.boltLauncher
          ];
        }

        (lib.optionalAttrs (options.programs.niri ? wrapper) {
          programs.niri.wrapper.settings.window-rules = [
            {
              matches = [ { app-id = "BoltLauncher"; } ];
              open-floating = true;
            }
            {
              # RuneLite pop-up windows
              matches = [ { app-id = "net-runelite-client-RuneLite"; } ];
              excludes = [ { title = "RuneLite"; } ];
              open-floating = true;
            }
            {
              # RuneLite opacity toggle
              matches = [ { app-id = "net-runelite-client-RuneLite"; } ];
              excludes = [ { title = "RuneLite .+"; } ];
              opacity = 0.4;
              draw-border-with-background = false;
            }
          ];
        })
      ];
    };
}
