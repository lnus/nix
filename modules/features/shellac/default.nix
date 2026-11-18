{ inputs, ... }:
{
  # github.com/lnus/shellac
  # user service in the graphical session; for now only replaces noctalia bar.
  flake.nixosModules.shellac =
    { options, lib, ... }:
    {
      imports = [ inputs.shellac.nixosModules.default ];

      config = lib.optionalAttrs (options.programs.noctalia ? wrapper) {
        # shellac draws the bar; the rest of Noctalia stays
        programs.noctalia.wrapper.settings.bar.default.enabled = false;
      };
    };
}
