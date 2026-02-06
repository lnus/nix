{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.stylix;
in {
  options.features.stylix.enable = lib.mkEnableOption "enable stylix";

  config = lib.mkIf cfg.enable {
    stylix = {
      enable = true;
      base16Scheme = ./miasma.yaml;
      polarity = "dark";

      fonts = let
        monaspace = {
          package = pkgs.nerd-fonts.monaspace;
          name = "MonaspiceKr Nerd Font";
        };
      in {
        serif = monaspace;
        sansSerif = monaspace;
        monospace = monaspace;
      };
    };
  };
}
