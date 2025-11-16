{
  inputs,
  config,
  lib,
  ...
}: let
  wallpaperDir = "${config.home.homeDirectory}/Pictures/Wallpapers";
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;

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

      wallpaper = {
        enabled = true;
        directory = "${wallpaperDir}";
        defaultWallpaper = "${wallpaperDir}/default.png";

        # TEMP Probably change this I think, doesn't feel great
        # or at least track within flake...
        monitors = [
          {
            directory = "${wallpaperDir}";
            name = "DP-3";
            wallpaper = "${wallpaperDir}/long.png";
          }
          {
            directory = "${wallpaperDir}";
            name = "DP-4";
            wallpaper = "${wallpaperDir}/wide.png";
          }
        ];
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
