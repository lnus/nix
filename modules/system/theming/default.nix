{ self, ... }: {
  flake.nixosModules.theming =
    { pkgs, ... }:
    let
      gtkTheme = "Gruvbox-Dark";
      iconTheme = "Colloid-Purple";
      gtkSettings = ''
        [Settings]
        gtk-theme-name=${gtkTheme}
        gtk-icon-theme-name=${iconTheme}
        gtk-application-prefer-dark-theme=true
      '';

      # libadwaita ignores gtk-theme-name and only reads its colour variables from
      # ~/.config/gtk-4.0/gtk.css, so generate that from the shared palette instead.
      libadwaitaColors =
        c:
        let
          vars = {
            accent-color = c.accent;
            accent-bg-color = c.accent;
            accent-fg-color = c.on-accent;

            destructive-color = c.error;
            destructive-bg-color = c.error;
            destructive-fg-color = c.on-accent;
            success-color = c.success;
            success-bg-color = c.success;
            success-fg-color = c.on-accent;
            warning-color = c.warning;
            warning-bg-color = c.warning;
            warning-fg-color = c.on-accent;
            error-color = c.error;
            error-bg-color = c.error;
            error-fg-color = c.on-accent;

            window-bg-color = c.background;
            window-fg-color = c.text;
            view-bg-color = c.background;
            view-fg-color = c.text;
            headerbar-bg-color = c.background;
            headerbar-fg-color = c.text;
            headerbar-border-color = c.border;
            headerbar-backdrop-color = c.background;
            sidebar-bg-color = c.surface;
            sidebar-fg-color = c.text;
            sidebar-backdrop-color = c.surface;
            secondary-sidebar-bg-color = c.surface;
            secondary-sidebar-fg-color = c.text;
            card-bg-color = c.surface;
            card-fg-color = c.text;
            dialog-bg-color = c.surface;
            dialog-fg-color = c.text;
            popover-bg-color = c.surface;
            popover-fg-color = c.text;
            thumbnail-bg-color = c.surface;
            thumbnail-fg-color = c.text;
          };
        in
        ":root {\n"
        + pkgs.lib.concatStrings (pkgs.lib.mapAttrsToList (name: value: "  --${name}: ${value};\n") vars)
        + "}\n";
      libadwaitaCss = pkgs.writeText "gtk4-theme.css" ''
        ${libadwaitaColors self.theme.ui.light}
        @media (prefers-color-scheme: dark) {
        ${libadwaitaColors self.theme.ui.dark}
        }
      '';
    in
    {
      environment.systemPackages = with pkgs; [
        gruvbox-gtk-theme
        (colloid-icon-theme.override { colorVariants = [ "purple" ]; })
        kdePackages.breeze-icons # Inherits=breeze
        (self.theme.cursor.package pkgs)
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
