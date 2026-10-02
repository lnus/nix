{ self, ... }: {
  perSystem = { pkgs, ... }: {
    # Shared font closure; consumed by wrapped apps (e.g. kitty) and installed system-wide.
    packages.fonts = pkgs.buildEnv {
      name = "voidarc-fonts";
      paths = with pkgs; [
        (google-fonts.override {
          fonts = [
            "Lora"
            "Inter"
          ];
        })
        nerd-fonts.monaspace
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];
    };
  };

  flake.nixosModules.fonts = { pkgs, ... }: {
    fonts = {
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fonts
      ];

      # Theme fonts first; they have no CJK glyphs, so those fall through to
      # the JP variant (listed as the first CJK font, so Han gets Japanese forms).
      # Verify with: `fc-match -s sans-serif`
      fontconfig.defaultFonts = with self.theme.fonts; {
        sansSerif = [
          sans
          "Noto Sans CJK JP"
        ];
        serif = [
          serif
          "Noto Serif CJK JP"
        ];
        monospace = [
          mono
          "Noto Sans Mono CJK JP"
        ];
      };
    };
  };
}
