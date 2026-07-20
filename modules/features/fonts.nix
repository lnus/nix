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
      fontconfig.defaultFonts = {
        sansSerif = ["Noto Sans CJK JP" "Inter"];
        serif = ["Noto Serif CJK JP" "Lora"];
        monospace = ["Noto Sans Mono CJK JP" "MonaspiceKr Nerd Font"];
      };
    };
  };
}