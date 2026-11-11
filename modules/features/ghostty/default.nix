{
  self,
  inputs,
  ...
}:
let
  theme = self.theme.colors;
in
{
  flake.nixosModules.ghostty = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.ghostty
    ];

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "com.mitchellh.ghostty.desktop" ];
    };
  };

  perSystem = { pkgs, ... }: {
    packages.ghostty =
      let
        fontsConf = pkgs.makeFontsConf {
          fontDirectories = [ self.packages.${pkgs.stdenv.hostPlatform.system}.fonts ];
        };
        tabColors = pkgs.writeText "ghostty-tab-colors.css" ''
          tabbar tab {
            color: ${theme.base04};
          }

          tabbar tab:hover {
            background-color: ${theme.base01};
          }

          tabbar tab:selected,
          tabbar tab:selected:hover {
            color: ${theme.base05};
            background-color: ${theme.base01};
            box-shadow: inset 0 -2px ${theme.base0D};
          }
        '';
      in
      inputs.wrapper-modules.wrappers.ghostty.wrap {
        inherit pkgs;

        env.FONTCONFIG_FILE = "${fontsConf}";

        settings = {
          font-family = self.theme.fonts.mono;
          font-size = 10;
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

          foreground = theme.base05;
          background = theme.base00;
          cursor-color = theme.base05;
          selection-foreground = theme.base00;
          selection-background = theme.base05;

          palette = [
            "0=${theme.base00}"
            "1=${theme.base08}"
            "2=${theme.base0B}"
            "3=${theme.base0A}"
            "4=${theme.base0D}"
            "5=${theme.base0E}"
            "6=${theme.base0C}"
            "7=${theme.base05}"
            "8=${theme.base03}"
            "9=${theme.base08}"
            "10=${theme.base0B}"
            "11=${theme.base0A}"
            "12=${theme.base0D}"
            "13=${theme.base0E}"
            "14=${theme.base0C}"
            "15=${theme.base07}"
          ];

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
