{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.desktop.media;
in {
  options.features.desktop.media = {
    enable = lib.mkEnableOption "media and content creation tools";

    obs.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable OBS Studio";
    };

    graphics.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable graphics and illustration tools (Krita, etc.)";
    };

    video.enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable video editing tools";
    };
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    (lib.mkIf cfg.obs.enable {
      programs.obs-studio = {
        enable = true;
        package = pkgs.obs-studio.override {cudaSupport = true;};
      };
    })

    (lib.mkIf cfg.graphics.enable {
      environment.systemPackages = with pkgs; [
        krita
      ];
    })

    (lib.mkIf cfg.video.enable {
      environment.systemPackages = with pkgs; [
        kdePackages.kdenlive
        losslesscut-bin
      ];
    })
  ]);
}
