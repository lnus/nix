{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.ghostty = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty
    ];

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "com.mitchellh.ghostty.desktop" ];
    };

    environment.variables.LS_COLORS = builtins.concatStringsSep ":" [
      "rs=0"
      "di=01;35"
      "ln=03;35"
      "or=03;31"
      "mi=03;31"
      "ex=01;32"
      "pi=31"
      "so=31"
      "bd=31"
      "cd=31"
      "su=01;31"
      "sg=01;31"
      "tw=01;35"
      "ow=01;35"
      "st=01;35"
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.ghostty =
      let
        fontsConf = pkgs.makeFontsConf {
          fontDirectories = [ self.packages.${pkgs.stdenv.hostPlatform.system}.fonts ];
        };

        tabColors =
          let
            rules = c: ''
              tabbar {
                background-color: ${c.background};
              }

              tabbar tab,
              tabbar tab:hover,
              tabbar tab:selected {
                background: none;
                color: ${c.muted};
              }

              tabbar tab:hover {
                color: ${c.text};
              }

              tabbar tab:selected {
                color: ${c.text};
                box-shadow: inset 0 -2px ${c.accent};
              }
            '';
          in
          pkgs.writeText "ghostty-tab-colors.css" ''
            ${rules self.theme.ui.light}

            @media (prefers-color-scheme: dark) {
            ${rules self.theme.ui.dark}
            }
          '';

        # later keys win in a theme file
        desktopTheme =
          name: c:
          pkgs.runCommand "ghostty-theme" { } ''
            cat "${pkgs.ghostty}/share/ghostty/themes/${name}" > $out
            printf 'background = ${c.background}\nforeground = ${c.text}\n' >> $out
          '';
      in
      inputs.wrapper-modules.wrappers.ghostty.wrap {
        inherit pkgs;

        env.FONTCONFIG_FILE = "${fontsConf}";

        settings = {
          font-family = self.theme.fonts.mono;
          font-size = 10;
          adjust-cell-height = "10%";
          window-padding-x = 9;
          window-padding-y = 9;
          gtk-titlebar = false;
          cursor-style = "bar";
          resize-overlay = "never";
          window-theme = "ghostty";
          gtk-toolbar-style = "flat";
          gtk-wide-tabs = false;
          gtk-custom-css = [
            "${./tabs.css}"
            "${tabColors}"
          ];

          theme = "light:${desktopTheme "Rose Pine Dawn" self.theme.ui.light},dark:${desktopTheme "Rose Pine" self.theme.ui.dark}";

          keybind = [
            "alt+h=goto_split:left"
            "alt+j=goto_split:down"
            "alt+k=goto_split:up"
            "alt+l=goto_split:right"

            "alt+v=new_split:right"
            "alt+s=new_split:down"
            "alt+t=new_tab"
            "alt+q=close_surface"
            "alt+z=toggle_split_zoom"
            "alt+r=activate_key_table:resize"

            "resize/h=resize_split:left,20"
            "resize/j=resize_split:down,20"
            "resize/k=resize_split:up,20"
            "resize/l=resize_split:right,20"
            "resize/equal=equalize_splits"
            "resize/escape=deactivate_key_table"
            "resize/enter=deactivate_key_table"
            "resize/catch_all=ignore"
          ];
        };
      };
  };
}
