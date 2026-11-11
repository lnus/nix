{ self, ... }: {
  flake.nixosModules.theming =
    {
      options,
      lib,
      pkgs,
      ...
    }:
    let
      gtkTheme = {
        dark = "Desktop-dark";
        light = "Desktop";
      };
      iconTheme = "Colloid-Purple";
      gtkSettings = ''
        [Settings]
        gtk-theme-name=${gtkTheme.dark}
        gtk-icon-theme-name=${iconTheme}
      '';

      # libadwaita's colour names, filled from the shared palette
      colorRoles = c: {
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

      # libadwaita ignores gtk-theme-name and only reads its colour variables from
      # ~/.config/gtk-4.0/gtk.css, so generate that from the shared palette instead.
      gtk4Vars =
        c:
        ":root {\n"
        + lib.concatStrings (lib.mapAttrsToList (name: value: "  --${name}: ${value};\n") (colorRoles c))
        + "}\n";
      libadwaitaCss = pkgs.writeText "gtk4-theme.css" ''
        ${gtk4Vars self.theme.ui.light}
        @media (prefers-color-scheme: dark) {
        ${gtk4Vars self.theme.ui.dark}
        }
      '';

      # GTK3 can't switch colours by colour scheme, only by theme name: adw-gtk3's
      # light and dark variants with the palette appended, swapped by the Noctalia hook below
      gtk3Colors =
        c:
        lib.concatStrings (
          lib.mapAttrsToList (
            name: value: "@define-color ${lib.replaceStrings [ "-" ] [ "_" ] name} ${value};\n"
          ) (colorRoles c)
        );
      gtk3Theme = pkgs.runCommand "desktop-gtk-theme" { } ''
        themes=$out/share/themes
        mkdir -p $themes
        cp -r ${pkgs.adw-gtk3}/share/themes/adw-gtk3 $themes/${gtkTheme.light}
        cp -r ${pkgs.adw-gtk3}/share/themes/adw-gtk3-dark $themes/${gtkTheme.dark}
        chmod -R u+w $themes
        for t in ${gtkTheme.light} ${gtkTheme.dark}; do
          rm -r $themes/$t/gtk-4.0
          sed -i "s/adw-gtk3\(-dark\)\?/$t/" $themes/$t/index.theme
          cat ${pkgs.writeText "dark.css" (gtk3Colors self.theme.ui.dark)} >> $themes/$t/gtk-3.0/gtk-dark.css
        done
        cat ${pkgs.writeText "light.css" (gtk3Colors self.theme.ui.light)} >> $themes/${gtkTheme.light}/gtk-3.0/gtk.css
        cat ${pkgs.writeText "dark.css" (gtk3Colors self.theme.ui.dark)} >> $themes/${gtkTheme.dark}/gtk-3.0/gtk.css
      '';

      switchGtkTheme = pkgs.writeShellScript "switch-gtk-theme" ''
        theme=${gtkTheme.dark}
        [ "$NOCTALIA_THEME_MODE" = light ] && theme=${gtkTheme.light}
        ${lib.getExe pkgs.dconf} write /org/gnome/desktop/interface/gtk-theme "'$theme'"
      '';
    in
    {
      config = lib.mkMerge [
        {
          environment.systemPackages = with pkgs; [
            gtk3Theme
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
                gtk-theme = gtkTheme.dark;
                icon-theme = iconTheme;
                font-name = "${self.theme.fonts.sans} 10";
                document-font-name = "${self.theme.fonts.serif} 11";
                monospace-font-name = "${self.theme.fonts.mono} 10";
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
        }

        (lib.optionalAttrs (options.programs.noctalia ? wrapper) {
          programs.noctalia.wrapper.settings.hooks.theme_mode_changed = "${switchGtkTheme}";
        })
      ];
    };
}
