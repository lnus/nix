{ ... }: {
  # Shared look, read as `self.theme.<part>`.
  flake.theme = {
    ui = {
      dark = {
        background = "#1c1c1e";
        surface = "#2c2c2e"; # sidebars, cards, popovers, the bar
        raised = "#3a3a3c"; # controls and hover on a surface
        border = "#48484a";
        text = "#f5f5f7";
        muted = "#98989d";
        accent = "#c4a7e7";
        on-accent = "#1c1c1e";
        error = "#eb6f92";
        warning = "#f6c177";
        success = "#9ccfd8";
      };
      light = {
        background = "#f5f5f7";
        surface = "#ffffff";
        raised = "#e8e8ed";
        border = "#d1d1d6";
        text = "#1d1d1f";
        muted = "#6e6e73";
        accent = "#7a62a3"; # deeper than dawn's iris, so white text holds up on it
        on-accent = "#ffffff";
        error = "#b4637a";
        warning = "#ea9d34";
        success = "#286983";
      };
    };

    # Rosé Pine (main / dawn), for terminals and TUIs without a built-in Rosé Pine theme
    terminal = {
      dark = {
        base = "#191724";
        surface = "#1f1d2e";
        overlay = "#26233a";
        muted = "#6e6a86";
        subtle = "#908caa";
        text = "#e0def4";
        love = "#eb6f92";
        gold = "#f6c177";
        rose = "#ebbcba";
        pine = "#31748f";
        foam = "#9ccfd8";
        iris = "#c4a7e7";
      };
      light = {
        base = "#faf4ed";
        surface = "#fffaf3";
        overlay = "#f2e9e1";
        muted = "#9893a5";
        subtle = "#797593";
        text = "#575279";
        love = "#b4637a";
        gold = "#ea9d34";
        rose = "#d7827e";
        pine = "#286983";
        foam = "#56949f";
        iris = "#907aa9";
      };
    };

    radius = 8;

    # family names only; packages live in features/fonts
    fonts = {
      sans = "IBM Plex Sans";
      serif = "Source Serif 4";
      mono = "CommitMono Nerd Font";
    };

    cursor = {
      name = "macOS";
      size = 24;
      package = pkgs: pkgs.apple-cursor;
    };
  };
}
