{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.desktop.ime;
in {
  options.features.desktop.ime = {
    enable = lib.mkEnableOption "enable ime";
    wayland = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Wayland session";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    {
      i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5 = {
          addons = with pkgs; [
            fcitx5-mozc
            fcitx5-gtk
          ];

          waylandFrontend = cfg.wayland;
        };
      };
    }
    (lib.mkIf (cfg.wayland) {
      environment.variables = {
        GTK_IM_MODULE = lib.mkForce "";
      };
    })
  ]);
}
