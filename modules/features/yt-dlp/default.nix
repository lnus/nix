{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.yt-dlp = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.yt-dlp
    ];
  };

  perSystem = { pkgs, lib, ... }: {
    packages.yt-dlp =
      let
        # The wrapper renders values unquoted; yt-dlp splits config lines like a shell.
        q = lib.escapeShellArg;
        alias = name: opts: "${name} ${q (lib.concatStringsSep " " opts)}";
      in
      inputs.wrapper-modules.wrappers.yt-dlp.wrap {
        inherit pkgs;

        settings = {
          paths = q "~/Videos";
          output = q "%(extractor_key)s/%(channel,uploader,uploader_id|Unknown)s/%(upload_date>%Y-%m-%d)s %(title).120B [%(id)s].%(ext)s";

          # Folder names for the site directory.
          replace-in-metadata = [
            "extractor_key ^Youtube$ YouTube"
            "extractor_key ^Twitter$ X"
          ];

          # Same as `-t mp4`: H.264/AAC plays everywhere it gets shared to.
          format-sort = q "vcodec:h264,lang,quality,res,fps,hdr:12,acodec:aac";
          merge-output-format = "mp4";
          remux-video = "mp4";
          embed-metadata = true;
          embed-thumbnail = true;
          embed-chapters = true;
          embed-subs = true;
          sub-langs = q "en.*";
          sponsorblock-mark = "all";

          # Alias options go through str.format, so templates must not contain braces.
          alias = [
            (alias "archive" [
              "--format-sort-reset --merge-output-format mkv --remux-video mkv"
            ])
            (alias "music" [
              "--format-sort-reset -f ba -x --audio-format opus"
              "--parse-metadata ${q "title:^(?P<artist>.+?) [-–] (?P<title>.+)$"}"
              "--replace-in-metadata title ${q "(?i) *[(\\[][^)\\]]*(official|lyrics?|audio|remaster|video|visuali[sz]er)[^)\\]]*[)\\]]"} ''"
              "-P ${q "~/Music"}"
              "-o ${q "%(artist,creator,channel,uploader)s/%(album|Singles)s/%(track,title)s.%(ext)s"}"
            ])
            (alias "playlist" [
              "-o ${q "%(extractor_key)s/%(playlist_title,playlist)s/%(playlist_index)03d - %(title).120B.%(ext)s"}"
            ])
          ];
        };
      };
  };
}
