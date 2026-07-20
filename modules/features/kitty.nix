{
  self,
  inputs,
  ...
}: let
  theme = self.theme;
in {
  flake.nixosModules.kitty = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.kitty
    ];
  };

  perSystem = {pkgs, ...}: {
    packages.kitty = let
      # Pulls the font closure into `.#kitty`'s own build.
      fontsPkg = self.packages.${pkgs.stdenv.hostPlatform.system}.fonts;
      fontsConf = pkgs.makeFontsConf {
        fontDirectories = [fontsPkg];
      };
    in
      inputs.wrapper-modules.wrappers.kitty.wrap {
        inherit pkgs;

        environment = {
          "FONTCONFIG_FILE" = "${fontsConf}";
        };

        font = {
          name = "MonaspiceKr Nerd Font";
          size = 11;
        };

        settings = {
          font_size = 11;
          scrollbar = "never";
          window_padding_width = 9;
          enable_audio_bell = false;
          cursor_trail = 1;
          cursor_trail_start_threshold = 1;
          cursor_trail_color = theme.base0E;
          cursor_shape = "beam";
          allow_remote_control = true;
          enabled_layouts = "splits";

          foreground = theme.base05;
          background = theme.base00;
          cursor = theme.base05;
          selection_foreground = theme.base00;
          selection_background = theme.base05;

          color0 = theme.base00;
          color1 = theme.base08;
          color2 = theme.base0B;
          color3 = theme.base0A;
          color4 = theme.base0D;
          color5 = theme.base0E;
          color6 = theme.base0C;
          color7 = theme.base05;
          color8 = theme.base03;
          color9 = theme.base08;
          color10 = theme.base0B;
          color11 = theme.base0A;
          color12 = theme.base0D;
          color13 = theme.base0E;
          color14 = theme.base0C;
          color15 = theme.base07;
        };

        keybindings = {
          "alt+h" = "neighboring_window left";
          "alt+j" = "neighboring_window down";
          "alt+k" = "neighboring_window up";
          "alt+l" = "neighboring_window right";

          "alt+shift+h" = "move_window left";
          "alt+shift+j" = "move_window down";
          "alt+shift+k" = "move_window up";
          "alt+shift+l" = "move_window right";

          "alt+n" = "launch";
          "alt+v" = "launch --location=vsplit";
          "alt+s" = "launch --location=hsplit";
          "alt+q" = "close_window";
        };
      };
  };
}
