{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

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
        density = "compact";
        showCapsule = false;
      };

      general = {
        radiusRatio = 0.0;
      };

      # TEMP Potentially ditch this and use swww
      # FIX: dynamic per user
      wallpaper = {
        enabled = true;
        directory = "/home/linus/Pictures/Wallpapers";
      };

      colorSchemes = {
        useWallpaperColors = false;
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
