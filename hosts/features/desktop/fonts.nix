{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.desktop.fonts;

  gfonts = pkgs.google-fonts.override {
    fonts = ["Lora" "Inter"];
  };
in {
  options.features.desktop.fonts = {
    cjk = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable CJK fonts (default = true)";
    };
  };

  config = lib.mkMerge [
    {
      fonts = {
        packages = with pkgs; [
          gfonts
          nerd-fonts.monaspace
        ];

        fontconfig.defaultFonts = {
          serif = ["Lora"];
          sansSerif = ["Inter"];
          monospace = ["MonaspiceKr Nerd Font"];
        };
      };
    }

    (lib.mkIf cfg.cjk {
      # NOTE: Defaults to Japanese CJK glyphs without explicit fontconfig rules.
      # I have put them there anyways, because I prefer JP being the default as explicit.
      fonts = {
        packages = with pkgs; [
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];

        # CJK prepended so it's preferred for CJK glyphs but falls back
        # This can be verified with: `fc-match -s`
        fontconfig.defaultFonts = {
          sansSerif = ["Noto Sans CJK JP" "Lora"];
          serif = ["Noto Serif CJK JP" "Inter"];
          monospace = ["Noto Sans Mono CJK JP" "MonaspiceKr Nerd Font"];
        };
      };
    })
  ];
}
