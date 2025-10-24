{inputs, ...}: {
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia-shell = {
    enable = true;

    settings = {
      bar = {
        density = "compact";
      };

      general = {
        radiusRatio = 0.0;
      };

      templates = {
        gtk = true;
        qt = true;
        kcolorscheme = true;

        ghostty = true;

        discord_vesktop = true;
      };
    };
  };
}
