{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # TEMP move somewhere nicer, maybe
  services.swww.enable = true;

  programs.noctalia-shell = {
    enable = true;

    # TODO: this might break if stylix isn't enabled
    colors = lib.mkIf (config.stylix.enable or false) (
      with config.lib.stylix.colors; {
        mError = "#${base08}";
        mOnError = "#${base00}";
        mOnPrimary = "#${base00}";
        mOnSecondary = "#${base00}";
        mOnSurface = "#${base04}";
        mOnSurfaceVariant = "#${base04}";
        mOnTertiary = "#${base00}";
        mOutline = "#${base02}";
        mPrimary = "#${base0B}";
        mSecondary = "#${base0A}";
        mShadow = "#${base00}";
        mSurface = "#${base00}";
        mSurfaceVariant = "#${base01}";
        mTertiary = "#${base0D}";
      }
    );

    settings = {
      bar = {
        position = "left";
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

      wallpaper = {
        enabled = false;
      };

      colorSchemes = {
        useWallpaperColors = false;
        generateTemplatesForPredefined = false;
      };

      location = {
        name = "Stockholm";
        showWeekNumberInCalendar = true;
      };

      brightness = {
        enforceMinimum = false;
      };

      nightLight = {
        enabled = true;
      };
    };
  };

  programs.noctalia-shell.settings.ui =
    {
      # Any non-conditional
    }
    // (lib.optionalAttrs (config.stylix.enable or false) {
      fontFixed = config.stylix.fonts.monospace.name;
      fontDefault = config.stylix.fonts.sansSerif.name;
    });
}
