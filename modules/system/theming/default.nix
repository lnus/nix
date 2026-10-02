{ self, ... }: {
  flake.nixosModules.theming =
    { pkgs, ... }:
    let
      gtkTheme = "Gruvbox-Dark";
      iconTheme = "Gruvbox-Plus-Dark";
      gtkSettings = ''
        [Settings]
        gtk-theme-name=${gtkTheme}
        gtk-icon-theme-name=${iconTheme}
        gtk-application-prefer-dark-theme=true
      '';

      # libadwaita ignores gtk-theme-name and only reads named color overrides from
      # ~/.config/gtk-4.0/gtk.css, so generate that from the shared palette instead
      libadwaitaCss =
        with self.theme.colors;
        pkgs.writeText "gtk4-theme.css" ''
          @define-color accent_color ${base0D};
          @define-color accent_bg_color ${base0D};
          @define-color accent_fg_color ${base00};

          @define-color destructive_color ${base08};
          @define-color destructive_bg_color ${base08};
          @define-color destructive_fg_color ${base00};
          @define-color success_color ${base0B};
          @define-color success_bg_color ${base0B};
          @define-color success_fg_color ${base00};
          @define-color warning_color ${base0A};
          @define-color warning_bg_color ${base0A};
          @define-color warning_fg_color ${base00};
          @define-color error_color ${base08};
          @define-color error_bg_color ${base08};
          @define-color error_fg_color ${base00};

          @define-color window_bg_color ${base00};
          @define-color window_fg_color ${base05};
          @define-color view_bg_color ${base00};
          @define-color view_fg_color ${base05};
          @define-color headerbar_bg_color ${base01};
          @define-color headerbar_fg_color ${base05};
          @define-color headerbar_border_color ${base02};
          @define-color headerbar_backdrop_color ${base00};
          @define-color sidebar_bg_color ${base01};
          @define-color sidebar_fg_color ${base05};
          @define-color sidebar_backdrop_color ${base00};
          @define-color secondary_sidebar_bg_color ${base01};
          @define-color secondary_sidebar_fg_color ${base05};
          @define-color card_bg_color ${base01};
          @define-color card_fg_color ${base05};
          @define-color dialog_bg_color ${base01};
          @define-color dialog_fg_color ${base05};
          @define-color popover_bg_color ${base01};
          @define-color popover_fg_color ${base05};
          @define-color thumbnail_bg_color ${base01};
          @define-color thumbnail_fg_color ${base05};
        '';
    in
    {
      environment.systemPackages = with pkgs; [
        gruvbox-gtk-theme
        # upstream propagates breeze-icons' -dev output (dragging in qtbase-dev & co.), and
        # propagated inputs never reach the system profile anyway, so install the fallback directly
        (gruvbox-plus-icons.overrideAttrs { propagatedBuildInputs = [ ]; })
        kdePackages.breeze-icons # Inherits=breeze-dark
      ];

      environment.etc = {
        "xdg/gtk-3.0/settings.ini".text = gtkSettings;
        "xdg/gtk-4.0/settings.ini".text = gtkSettings;
      };

      # libadwaita takes dark mode from this (via the settings portal), not from settings.ini
      programs.dconf.profiles.user.databases = [
        {
          settings."org/gnome/desktop/interface" = {
            color-scheme = "prefer-dark";
            gtk-theme = gtkTheme;
            icon-theme = iconTheme;
          };
        }
      ];

      systemd.user.tmpfiles.rules = [ "L+ %h/.config/gtk-4.0/gtk.css - - - - ${libadwaitaCss}" ];

      # Qt's built-in gtk3 platform theme reads the GTK settings above,
      # so Qt apps (e.g. obs) follow the same theme and icons
      environment.sessionVariables.QT_QPA_PLATFORMTHEME = "gtk3";

      # unwrapped GIO apps (e.g. noctalia) can't read the dconf values above without the schema
      environment.sessionVariables.XDG_DATA_DIRS = [
        (pkgs.glib.getSchemaDataDirPath pkgs.gsettings-desktop-schemas)
      ];
    };
}
