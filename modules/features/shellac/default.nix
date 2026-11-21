{ inputs, ... }:
{
  # github.com/lnus/shellac
  # user service in the graphical session; replaces noctalia's bar, wallpaper,
  # media keys, night light and launcher.
  flake.nixosModules.shellac =
    {
      options,
      lib,
      pkgs,
      ...
    }:
    let
      ipc =
        cmd:
        [
          (lib.getExe inputs.shellac.packages.${pkgs.stdenv.hostPlatform.system}.default)
          "ipc"
          "call"
        ]
        ++ (lib.splitString " " cmd);
      key = cmd: _: {
        props.allow-when-locked = true;
        content.spawn = ipc cmd;
      };
    in
    {
      imports = [ inputs.shellac.nixosModules.default ];

      config = lib.mkMerge [
        {
          programs.shellac.settings = {
            # shellac expands `~/`, not $HOME
            wallpaper.directory = "~/Pictures/Wallpapers";
            # the night light's schedule: the sun in Falun. Mode and temperature
            # are shellac's state, set from its bar.
            nightlight = {
              latitude = 60.6;
              longitude = 15.6;
            };
          };
        }
        (lib.optionalAttrs (options.programs.noctalia ? wrapper) {
          # shellac does these; the rest of Noctalia stays. mkForce over
          # noctalia's own `enabled = true`. One night light only: a second
          # gamma client gets nowhere.
          programs.noctalia.wrapper.settings = {
            bar.default.enabled = false;
            wallpaper.enabled = lib.mkForce false;
            backdrop.enabled = lib.mkForce false;
            nightlight.enabled = lib.mkForce false;
          };
        })
        (lib.optionalAttrs (options.programs.niri ? wrapper) {
          # The wallpaper sits on every workspace; shellac's backdrop (a
          # blurred copy) fills the space around them in the overview.
          programs.niri.wrapper.settings.layer-rules = [
            {
              matches = [ { namespace = "^shellac-backdrop$"; } ];
              place-within-backdrop = true;
            }
          ];
          # shellac's `shot` runs a nested niri as a window (app-id and title
          # are fixed to "niri"). Open it out of the way, so it doesn't pop into
          # the layout or take focus; hosts with a second screen send it there.
          programs.niri.wrapper.settings.window-rules = [
            {
              matches = [ { app-id = "^niri$"; } ];
              open-floating = true;
              open-focused = false;
            }
          ];
          programs.niri.wrapper.binds = {
            "Mod+D" = _: {
              props.hotkey-overlay-title = "Launcher";
              content.spawn = ipc "launcher toggle";
            };
            "XF86AudioRaiseVolume" = key "volume up";
            "XF86AudioLowerVolume" = key "volume down";
            "XF86AudioMute" = key "volume mute";
            "XF86AudioMicMute" = key "mic mute";
            "XF86AudioPlay" = key "media toggle";
            "XF86AudioNext" = key "media next";
            "XF86AudioPrev" = key "media previous";
          };
        })
      ];
    };
}
