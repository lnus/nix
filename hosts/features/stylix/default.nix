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
      base16Scheme = ./charcoal-tweak.yaml;
      polarity = "dark";

      fonts = {
        serif = {
          package = pkgs.nerd-fonts.go-mono;
          name = "GoMono Nerd Font";
        };

        sansSerif = {
          package = pkgs.nerd-fonts.go-mono;
          name = "GoMono Nerd Font";
        };

        monospace = {
          package = pkgs.nerd-fonts.go-mono;
          name = "GoMono Nerd Font";
        };
      };
    };
  };
}
