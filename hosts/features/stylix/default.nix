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
        gfonts = pkgs.google-fonts.override {
          fonts = ["Lora" "Inter"];
        };
      in {
        serif = {
          package = gfonts;
          name = "Lora";
        };
        sansSerif = {
          package = gfonts;
          name = "Inter";
        };
        monospace = {
          package = pkgs.nerd-fonts.monaspace;
          name = "MonaspiceKr Nerd Font";
        };
      };
    };
  };
}
