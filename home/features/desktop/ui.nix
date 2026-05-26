# TODO: unclear name
{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.features.desktop.ui;
in {
  options.features.desktop.ui = {
    enable = lib.mkEnableOption "enable cursor + icon pack";

    cursorSize = lib.mkOption {
      type = lib.types.int;
      default = 24;
      description = "Cursor size";
    };
  };

  config = lib.mkIf cfg.enable {
    # gtk4 no longer inherits gtk.theme by default in 26.05+
    gtk.gtk4.theme = config.gtk.theme;

    # TODO: fix
    gtk.iconTheme = {
      package = pkgs.tela-circle-icon-theme;
      name = "Tela-circle-dark";
    };

    home.pointerCursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Original-Classic";
      size = cfg.cursorSize;
      gtk.enable = true;
      x11.enable = true;
    };
  };
}
