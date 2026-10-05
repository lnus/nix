{
  self,
  inputs,
  ...
}:
let
  theme = self.theme.colors;
in
{
  flake.nixosModules.mpv = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.mpv
    ];
  };

  perSystem = { pkgs, ... }: {
    packages.mpv = inputs.wrapper-modules.wrappers.mpv.wrap {
      inherit pkgs;

      "mpv.conf".content = ''
        profile=high-quality
        vo=gpu-next
        hwdec=auto-safe

        volume=50
        keep-open=yes
        save-position-on-quit=yes
        watch-later-options-remove=sub-pos
        watch-later-options-remove=volume
        autofit-larger=80%x80%
        autocreate-playlist=filter
        directory-filter-types=video,audio

        # ModernZ replaces the built-in OSC.
        osc=no
        osd-fonts-dir=${pkgs.mpvScripts.modernz}/share/fonts/truetype

        alang=ja,jpn,en,eng
        slang=en,eng
        subs-with-matching-audio=no
        sub-font=${self.theme.fonts.sans}
        sub-border-size=2

        screenshot-format=png
        screenshot-dir=~/Pictures/Screenshots/mpv
        screenshot-template=%F %wH.%wM.%wS
      '';

      script = {
        modernz = {
          path = pkgs.mpvScripts.modernz;
          opts = {
            seekbarfg_color = theme.base09;
            seek_handle_color = theme.base0F;
            seek_handle_border_color = theme.base09;
            hover_effect_color = theme.base09;
            seekbar_cache_color = theme.base04;
            title_color = theme.base05;
            thumbnail_box_color = theme.base00;
            thumbnail_box_outline = theme.base02;
          };
        };
        thumbfast.path = pkgs.mpvScripts.thumbfast;
      };
    };
  };
}
