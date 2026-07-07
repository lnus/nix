{
  self,
  inputs,
  ...
}: {
  flake.nixosModules.helix = {
    pkgs,
    lib,
    ...
  }: {
    environment.systemPackages =
      [
        self.packages.${pkgs.stdenv.hostPlatform.system}.myHelix
      ]
      ++ (with pkgs; [
        nixd # nix lsp
        alejandra # nix formatter
        prettier # markdown + general purpose formatter
        codebook # provides the `codebook-lsp` spellchecker binary
        tinymist # typst lsp
        typstyle # typst formatter
      ]);

    # TODO move this out of the helix module so it can be used generally
    environment.variables.EDITOR = "hx";
    environment.variables.VISUAL = "hx";
  };

  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    packages.myHelix = inputs.wrapper-modules.wrappers.helix.wrap {
      inherit pkgs;

      settings = {
        theme = "gruvbox";

        editor = {
          line-number = "relative";
          bufferline = "multiple";
          soft-wrap.enable = true;

          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };

          file-picker.hidden = false;

          indent-guides.render = true;
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
      };

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
