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
          # The wallpaper sits on every workspace; shellac's backdrop (a
          # blurred copy) fills the space around them in the overview.
          programs.niri.wrapper.settings.layer-rules = [
            {
              matches = [ { namespace = "^shellac-backdrop$"; } ];
              place-within-backdrop = true;
            }
          ];
        })
      ];
    };
}
