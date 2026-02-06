{
  pkgs,
  lib,
  config,
  stylixLib,
  ...
}: let
  cfg = config.features.cli.helix;

  c = stylixLib.mkBase16 config;
  isStylix = stylixLib.isStylix config;
  hash = builtins.hashString "md5" (builtins.toJSON c.hex);
in {
  options.features.cli.helix.enable = lib.mkEnableOption "enable helix configuration";

  config = lib.mkIf cfg.enable {
    # TODO
    # - move this out of the actual editor config so it can be used generally
    home.packages = with pkgs; [
      nixd # nix lsp
      alejandra # nix formatter
      prettier # markdown + general purpose formatter
    ];

    home.sessionVariables.EDITOR = "hx";
    stylix.targets.helix.enable = false; # Custom theme override used instead

    programs.helix = {
      enable = true;

      themes = lib.mkIf isStylix {
        "stylix-${hash}" = import ./theme.nix {inherit c;};
      };

      settings = lib.mkMerge [
        (lib.mkIf isStylix {
          theme = "stylix-${hash}";
        })

        (lib.mkIf (!isStylix) {
          theme = "gruvbox";
        })

        {
          editor = {
            line-number = "relative";
            bufferline = "multiple";
            soft-wrap.enable = true;

            cursor-shape = {
              normal = "block";
              insert = "bar";
              select = "underline";
            };

            file-picker = {
              hidden = false;
            };

            indent-guides = {
              render = true;
            };
          };

          keys = {
            normal = {
              esc = [
                "collapse_selection"
                "keep_primary_selection"
              ];

              # NOTE verbose, but leaving so i remember the config for later
              "space" = {
                t = {
                  i = ":toggle lsp.display-inlay-hints";
                };
              };
            };

            insert = {
              C-c = "toggle_comments";
            };
          };
        }
      ];

      languages = {
        language = [
          {
            name = "typst";
            language-servers = ["codebook" "tinymist"];
            formatter.command = "typstyle";
            auto-format = true;
          }
          {
            name = "nix";
            language-servers = ["nixd"];
            formatter.command = "alejandra";
            auto-format = true;
          }
          {
            name = "rust";
            auto-format = true;
          }
          {
            name = "markdown";
            auto-format = true;
            formatter = {
              command = "prettier";
              args = [
                "--parser"
                "markdown"
              ];
            };
          }
        ];

        language-server = {
          codebook = {
            command = "codebook-lsp";
            args = ["serve"];
          };
        };
      };
    };
  };
}
