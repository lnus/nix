{self, ...}: {
  perSystem = {pkgs, ...}: {
    # Shared font closure; consumed by wrapped apps (e.g. kitty) and installed system-wide.
    packages.fonts = pkgs.buildEnv {
      name = "voidarc-fonts";
      paths = with pkgs; [
        (google-fonts.override {fonts = ["Lora" "Inter"];})
        nerd-fonts.monaspace
        noto-fonts-cjk-sans
        noto-fonts-cjk-serif
      ];
    };
  };

  flake.nixosModules.fonts = {pkgs, ...}: {
    fonts = {
      packages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.fonts
      ];

      # CJK prepended so it's preferred for CJK glyphs but falls back.
      # Verify with: `fc-match -s`
      fontconfig.defaultFonts = with self.theme.fonts; {
        sansSerif = ["Noto Sans CJK JP" sans];
        serif = ["Noto Serif CJK JP" serif];
        monospace = ["Noto Sans Mono CJK JP" mono];
      };
    };
  };
}