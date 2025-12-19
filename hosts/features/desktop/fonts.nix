{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.features.desktop.fonts;
in {
  options.features.desktop.fonts = {
    # NOTE: Enabling by default, consider if it's better not doing that
    cjk = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Enable CJK fonts (default = true)";
    };
  };

  config = lib.mkMerge [
    (lib.mkIf (cfg.cjk) {
      # NOTE: Defaults to Japanese CJK glyphs without explicit fontconfig rules.
      # I have put them there anyways, because I prefer JP being the default as explicit.
      fonts = {
        packages = with pkgs; [
          noto-fonts-cjk-sans
          noto-fonts-cjk-serif
        ];

        # NOTE: This overwrites default font *if* you don't use Stylix.
        # Consider lib.mkMerge in that case. (Or setting per-app)
        #
        # This can be verified with: `fc-match -s`
        # ... "GoMono Nerd Font" "Regular" // Stylix font
        # ... "Noto Sans CJK JP" "Regular" // JP glyph preference
        fontconfig.defaultFonts = {
          sansSerif = ["Noto Sans CJK JP"];
          serif = ["Noto Serif CJK JP"];
          monospace = ["Noto Sans Mono CJK JP"];
        };
      };
    })
  ];
}
