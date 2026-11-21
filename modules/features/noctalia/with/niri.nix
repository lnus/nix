{ ... }: {
  flake.nixosModules.noctalia =
    {
      config,
      options,
      lib,
      ...
    }:
    let
      noctalia = lib.getExe config.programs.noctalia.package;
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
              {
                # without xray, blur shows the windows behind, not just the wallpaper
                matches = [
                  { namespace = "^noctalia-(bar-[^\"]+|notification|dock|panel|attached-panel|osd)$"; }
                  { namespace = "^noctalia-window-switcher"; }
                ];
                background-effect.xray = false;
              }
            ];
          };

          binds = {
            "Mod+Shift+E" = _: {
              props.hotkey-overlay-title = "Session Menu";
              content.spawn = msg "panel-toggle session";
            };

            "Super+Alt+L" = _: {
              props.allow-when-locked = true;
              props.hotkey-overlay-title = "Lock the Screen";
              content.spawn = msg "session lock";
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
