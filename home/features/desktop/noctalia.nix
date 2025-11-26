{
  inputs,
  config,
  lib,
  stylixLib,
  ...
}: let
  cfg = config.features.desktop.noctalia;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  options.features.desktop.noctalia.enable = lib.mkEnableOption "enable noctalia shell";

  config = lib.mkIf cfg.enable {
    programs.noctalia-shell = {
      enable = true;
      systemd.enable = true; # systemd startup service, consider making option

      colors = let
        c = stylixLib.mkBase16 config;
      in {
        mError = c.hex.base08;
        mOnError = c.hex.base00;
        mOnPrimary = c.hex.base00;
        mOnSecondary = c.hex.base00;
        mOnSurface = c.hex.base04;
        mOnSurfaceVariant = c.hex.base04;
        mOnTertiary = c.hex.base00;
        mOutline = c.hex.base02;
        mPrimary = c.hex.base0B;
        mSecondary = c.hex.base0A;
        mShadow = c.hex.base00;
        mSurface = c.hex.base00;
        mSurfaceVariant = c.hex.base01;
        mTertiary = c.hex.base0D;
      };

      settings = {
        ui = let
          f = stylixLib.getFont config;
        in {
          fontFixed = f.name;
          fontDefault = f.name;
        };

        sessionMenu.countdownDuration = 3000;

        bar = {
          position = "bottom";
          density = "compact";
          showCapsule = false;
        };

        dock = {
          enabled = false;
        };

        general = {
          radiusRatio = 0.0;
          enableShadows = false;
        };

        wallpaper.overviewEnabled = true;

        colorSchemes = {
          useWallpaperColors = false;
          generateTemplatesForPredefined = false;
        };

        location = {
          name = "Stockholm";
          showWeekNumberInCalendar = true;
        };

        nightLight = {
          enabled = true;
        };
      };
    };
  };
}
