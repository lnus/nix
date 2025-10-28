{
  inputs,
  config,
  lib,
  ...
}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = with config.lib.stylix.colors; {
    enable = true;

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

      # FIX: dynamic per user
      # Potentially ditch this and use swww
      wallpaper = {
        enabled = true;
        directory = "/home/linus/Pictures/Wallpapers";
      };

      # FIX: stylix fonts IF enabled
      ui = {
        fontDefault = "Roboto";
        fontFixed = "DejaVu Sans Mono";
        fontDefaultScale = 1;
        fontFixedScale = 1;
        tooltipsEnabled = true;
        panelsOverlayLayer = true;
      };

      colorSchemes = {
        useWallpaperColors = false;
      };
    };
  };
}
