{ self, ... }: {
  flake.nixosModules.noctalia =
    {
      options,
      lib,
      pkgs,
      ...
    }:
    let
      noctalia = lib.getExe self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia;
      msg =
        cmd:
        [
          noctalia
          "msg"
        ]
        ++ (lib.splitString " " cmd);
    in
    {
      config = lib.optionalAttrs (options.programs.niri ? wrapper) {
        programs.niri.wrapper = {
          settings = {
            spawn-at-startup = [ noctalia ];

            layer-rules = [
              {
                matches = [ { namespace = "^noctalia-backdrop"; } ];
                place-within-backdrop = true;
              }
            ];
          };

          binds = {
            "Mod+D" = _: {
              props.hotkey-overlay-title = "Launcher";
              content.spawn = msg "panel-toggle launcher";
            };

            "Mod+Shift+E" = _: {
              props.hotkey-overlay-title = "Session Menu";
              content.spawn = msg "panel-toggle session";
            };

            "Super+Alt+L" = _: {
              props.allow-when-locked = true;
              props.hotkey-overlay-title = "Lock the Screen";
              content.spawn = msg "session lock";
            };

            "XF86AudioRaiseVolume" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "volume-up";
            };
            "XF86AudioLowerVolume" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "volume-down";
            };
            "XF86AudioMute" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "volume-mute";
            };
            "XF86AudioMicMute" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "mic-mute";
            };
            "XF86AudioPlay" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "media toggle";
            };
            "XF86AudioNext" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "media next";
            };
            "XF86AudioPrev" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "media previous";
            };
            "XF86MonBrightnessUp" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "brightness-up";
            };
            "XF86MonBrightnessDown" = _: {
              props.allow-when-locked = true;
              content.spawn = msg "brightness-down";
            };
          };
        };
      };
    };
}
