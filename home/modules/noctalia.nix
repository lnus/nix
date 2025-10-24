{
  inputs,
  config,
  ...
}
: let
  c = config.lib.stylix.colors;
in {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # FIX: this is kinda jank
  # i attempted an overlay but i messed it up and i cba
  home.file.".config/noctalia/colors.json".text = builtins.toJSON {
    mPrimary = "#${c.base0B}";
    mOnPrimary = "#${c.base00}";
    mSecondary = "#${c.base0A}";
    mOnSecondary = "#${c.base00}";
    mTertiary = "#${c.base0D}";
    mOnTertiary = "#${c.base00}";
    mError = "#${c.base08}";
    mOnError = "#${c.base00}";
    mSurface = "#${c.base00}";
    mOnSurface = "#${c.base07}";
    mSurfaceVariant = "#${c.base01}";
    mOnSurfaceVariant = "#${c.base06}";
    mOutline = "#${c.base03}";
    mShadow = "#${c.base00}";
  };

  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        density = "compact";
        showCapsule = false;
      };

      general = {
        radiusRatio = 0.0;
      };

      # FIX: dynamic per user
      wallpaper = {
        enabled = true;
        directory = "/home/linus/Pictures/Wallpapers";
      };

      # FIX: stylix fonts
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
