# TODO: unclear name
{
  lib,
  pkgs,
  config,
  stylixLib,
  ...
}: let
  cfg = config.features.desktop.ui;
  isStylix = stylixLib.isStylix config;
in {
  options.features.desktop.ui = {
    enable = lib.mkEnableOption "enable cursor + icon pack";

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.enable && isStylix) {
      stylix.icons = {
        enable = true;
        package = pkgs.tela-circle-icon-theme;
        dark = "Tela-circle";
      };

      stylix.cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Original-Classic";
        size = cfg.cursorSize;
      };
    })

    # TODO add non-stylix alternative
  ];
}
