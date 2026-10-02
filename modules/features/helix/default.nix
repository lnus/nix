{
  self,
  inputs,
  ...
}:
{
  flake.nixosModules.helix =
    {
      pkgs,
      lib,
      ...
    }:
    {
      environment.systemPackages = [
        self.packages.${pkgs.stdenv.hostPlatform.system}.helix
      ]
      ++ (with pkgs; [
        nixd # nix lsp
        nixfmt # nix formatter
        prettier # markdown + general purpose formatter
        codebook # provides the `codebook-lsp` spellchecker binary
        tinymist # typst lsp
        typstyle # typst formatter
      ]);
    };

  perSystem =
    {
      pkgs,
      lib,
      inputs',
      ...
    }:
    let
      mapfileRuntime = inputs'.tree-sitter-mapfile.packages.helix-runtime;
    in
    {
      packages.helix = inputs.wrapper-modules.wrappers.helix.wrap (
        { config, ... }: {
          inherit pkgs;

          # `hx --grammar build` can't write to the store, so ship the prebuilt mapfile
          # grammar + queries in the wrapper's config dir; helix checks
          # <config dir>/runtime before its default runtime.
          buildCommand.mapfileGrammar = {
            after = [ "constructFiles" ];
            data = ''
              rt=${config.generatedConfig.placeholder}/helix/runtime
              mkdir -p "$rt/grammars" "$rt/queries"
              ln -s ${mapfileRuntime}/grammars/mapfile.so "$rt/grammars/mapfile.so"
              ln -s ${mapfileRuntime}/queries/mapfile "$rt/queries/mapfile"
            '';
          };

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
                language-servers = [
                  "codebook"
                  "tinymist"
                ];
                formatter.command = "typstyle";
                auto-format = true;
              }
              {
                name = "nix";
                language-servers = [ "nixd" ];
                formatter.command = "nixfmt";
                auto-format = true;
              }
              {
                name = "rust";
                auto-format = true;
              }
              inputs.tree-sitter-mapfile.lib.helixLanguage
              {
                name = "markdown";
                language-servers = [ "zk" ];
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
                args = [ "serve" ];
              };
              # only does anything inside a zk notebook (a dir with .zk/)
              zk = {
                command = "zk";
                args = [ "lsp" ];
              };
            };
          };
        }
      );
    };
}
