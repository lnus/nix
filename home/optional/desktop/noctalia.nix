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
  # it might be fine here
  services.swww.enable = true;

  programs.noctalia-shell = {
    enable = true;

    # TODO: this will break if stylix isn't enabled
    # not really sure what I was thinking here?????
    # config.stylix won't exist if I don't pull in stylix...
    # I guess I could lib.mkDefault false and then
    # enable it afterwards?
    # FIX FIX FIX
    colors = lib.mkIf config.stylix.enable (
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

  # FIX same issue as colors above
  programs.noctalia-shell.settings.ui =
    {
      # Any non-conditional
    }
    // (lib.optionalAttrs config.stylix.enable {
      fontFixed = config.stylix.fonts.monospace.name;
      fontDefault = config.stylix.fonts.sansSerif.name;
    });
}
