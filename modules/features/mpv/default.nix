{
  self,
  inputs,
  ...
}:
let
  # the OSC sits on top of video, so it stays dark
  theme = self.theme.ui.dark;
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
        screenshot-template="%F %wH.%wM.%wS"
      '';

      script = {
        modernz = {
          path = pkgs.mpvScripts.modernz;
          opts = {
            seekbarfg_color = theme.accent;
            seek_handle_color = theme.accent;
            seek_handle_border_color = theme.accent;
            hover_effect_color = theme.accent;
            seekbar_cache_color = theme.muted;
            title_color = theme.text;
            thumbnail_box_color = theme.background;
            thumbnail_box_outline = theme.border;
          };
        };
        thumbfast.path = pkgs.mpvScripts.thumbfast;
      };
    };
  };
}
