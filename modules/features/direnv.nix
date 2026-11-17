# no nixosModule: nushell (its PWD hook) and zed pull this in themselves
{ inputs, ... }:
{
  perSystem =
    { pkgs, ... }:
    {
      packages.direnv = inputs.wrapper-modules.wrappers.direnv.wrap {
        inherit pkgs;
        nix-direnv.enable = true;
        silent = true;
      };
    };
}
