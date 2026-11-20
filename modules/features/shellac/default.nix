{ inputs, ... }:
{
  # github.com/lnus/shellac
  # user service in the graphical session; replaces noctalia's bar and wallpaper.
  flake.nixosModules.shellac =
    { options, lib, ... }:
    {
      imports = [ inputs.shellac.nixosModules.default ];

      config = lib.mkMerge [
        {
          # shellac expands `~/`, not $HOME
          programs.shellac.settings.wallpaper.directory = "~/Pictures/Wallpapers";
        }
        (lib.optionalAttrs (options.programs.noctalia ? wrapper) {
          # shellac draws these; the rest of Noctalia stays. mkForce over
          # noctalia's own `enabled = true`.
          programs.noctalia.wrapper.settings = {
            bar.default.enabled = false;
            wallpaper.enabled = lib.mkForce false;
            backdrop.enabled = lib.mkForce false;
          };
        })
        (lib.optionalAttrs (options.programs.niri ? wrapper) {
          # One stationary wallpaper behind everything (niri's wiki, Overview):
          # in the backdrop, seen through transparent workspaces. It doesn't
          # slide on workspace switches, so the bar's glass always sits over
          # the same pixels.
          programs.niri.wrapper.settings = {
            layer-rules = [
              {
                matches = [ { namespace = "^shellac-wallpaper$"; } ];
                place-within-backdrop = true;
              }
            ];
            layout.background-color = "transparent";
          };
        })
      ];
    };
}
