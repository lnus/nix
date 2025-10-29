{
  pkgs,
  lib,
  ...
}: {
  programs.helix = {
    enable = true;

    extraPackages = with pkgs; [
      vscode-langservers-extracted
      python313Packages.jedi-language-server
    ];

    settings = {
      editor = {
        line-number = "relative";
        mouse = false;
        bufferline = "multiple";

        cursor-shape = {
          insert = "bar";
        };

        file-picker = {
          hidden = false;
        };

        lsp = {
          display-inlay-hints = true;
        };

        statusline = {
          left = ["mode" "file-name" "spinner"];
          center = [];
          right = ["diagnostics" "selections" "position" "position-percentage" "file-encoding" "file-type"];
          separator = "│";
          mode.normal = "normal";
          mode.insert = "insert";
          mode.select = "select";
        };

        indent-guides = {
          render = true;
          character = "┊";
          skip-levels = 0;
        };

        whitespace = {
          render = {
            nbsp = "all";
            tab = "all";
          };

          characters = {
            space = "·";
            nbsp = "⍽";
            nnbsp = "␣";
            tab = "→";
            newline = "⏎";
            tabpad = "·";
          };
        };
      };

      keys = {
        normal = {
          esc = [
            "collapse_selection"
            "keep_primary_selection"
          ];
        };
      };
    };

    # TODO: fix all these references.
    # TEMP these packages should probably not be global but be in dev flake...
    # but it's fine
    languages = {
      language = [
        {
          name = "typst";
          auto-format = true;
          formatter.command = "${lib.getExe pkgs.typstyle}";
          language-servers = ["codebook" "tinymist"];
        }
        {
          name = "nix";
          auto-format = true;
        }
        {
          name = "rust";
          auto-format = true;
        }
        {
          name = "python";
          auto-format = true;
        }
        {
          # TEMP
          name = "markdown";
          auto-format = true;
          formatter = {
            command = "${lib.getExe pkgs.deno}";
            args = [
              "fmt"
              "-"
              "--ext"
              "md"
            ];
          };
        }
      ];

      language-server = {
        codebook = {
          # spell checker
          command = "${lib.getExe pkgs.codebook}";
          args = ["serve"];
        };

        ruff = {
          command = "${lib.getExe pkgs.ruff}";
        };

        rust-analyzer = {
          config.rust-analyzer = {
            inlayHints = {
              maxLength = 30;
            };
          };
        };

        tinymist = {
          command = "${lib.getExe pkgs.tinymist}";
        };

        # https://github.com/helix-editor/helix/issues/14003#issuecomment-3093186464
        nixd = {
          command = "${lib.getExe pkgs.nixd}";
          args = ["--semantic-tokens=true"];
          config.nixd = let
            myFlake = "(builtins.getFlake (toString /home/linus/nix))";
            nixosOpts = "${myFlake}.nixosConfigurations.manin.options";
          in {
            nixpkgs.expr = "import ${myFlake}.inputs.nixpkgs { }";
            formatting.command = ["${lib.getExe pkgs.alejandra}"];
            options = {
              nixos.expr = nixosOpts;
              home-manager.expr = "${nixosOpts}.home-manager.users.type.getSubOptions []";
            };
          };
        };
      };
    };
  };
}
