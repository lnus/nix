{
  config,
  pkgs,
  lib,
  ...
}: let
in {
  home.username = "linus";
  home.homeDirectory = "/home/linus";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = [];

  home.file = let
  in {};

  home.sessionVariables = {
    SET_BY_HM = 1; # dummy var for testing
    EDITOR = "hx";
  };

  home.shellAliases = {
    la = "ls --all";
    ll = "ls --long";

    lla = "ls --long --all";
    sl = "ls";

    e = "hx";
    v = "hx";

    mv = "mv --verbose";
    rm = "rm --verbose";
    cp = "cp --verbose --recursive --progress";
  };

  home.sessionPath = [];

  # NOTE: This does a global override
  # No reason to put programs.<program>.enable<Shell>Integration = true;
  # https://github.com/nix-community/home-manager/blob/release-25.05/modules/misc/shell.nix
  # https://github.com/nix-community/home-manager/commit/5af1b9a0f193ab6138b89a8e0af8763c21bbf491
  home.shell.enableNushellIntegration = true;
  home.shell.enableBashIntegration = true;

  programs.bash = {
    enable = true;
  };

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

        # NOTE: I think this is correct? Since I'm not on NixOS it's... harder
        # https://github.com/helix-editor/helix/issues/14003#issuecomment-3093186464
        nixd = {
          command = "${lib.getExe pkgs.nixd}";
          args = ["--semantic-tokens=true"];
          config.nixd = let
            hmFlake = "(builtins.getFlake (toString ${config.home.homeDirectory}/.config/home-manager))";
            hmOpts = "${hmFlake}.homeConfigurations.${config.home.username}.options";
          in {
            nixpkgs.expr = "import ${hmFlake}.inputs.nixpkgs { }";
            formatting.command = ["${lib.getExe pkgs.alejandra}"];
            options = {
              home-manager.expr = "${hmOpts}";
            };
          };
        };
      };
    };
  };

  programs.nushell = {
    enable = true;

    settings = {
      buffer_editor = "hx";
      edit_mode = "vi";
      show_banner = false;
      cursor_shape = {
        vi_insert = "line";
        vi_normal = "block";
      };

      keybindings = [
        # TODO: write as nushell scripts? mkshellbin? something sane
        # https://github.com/junegunn/fzf/issues/4122#issuecomment-2607368316
        {
          name = "skim_dirs";
          modifier = "Alt";
          keycode = "char_c";
          mode = ["vi_insert" "vi_normal"];
          event = {
            send = "executehostcommand";
            cmd = ''
              let res = ${lib.getExe pkgs.fd} -t d
              | ${lib.getExe pkgs.skim} --preview "${lib.getExe pkgs.eza} --tree -L 2 {}";
              commandline edit --append $res;
              commandline set-cursor --end
            '';
          };
        }
        {
          name = "zoxide_interactive";
          modifier = "Alt";
          keycode = "char_z";
          mode = ["vi_insert" "vi_normal"];
          event = {
            send = "executehostcommand";
            cmd = ''
              let res = ${lib.getExe pkgs.zoxide} query -i;
              commandline edit --append $res;
              commandline set-cursor --end
            '';
          };
        }
      ];
    };

    shellAliases =
      config.home.shellAliases
      // {
        fg = "job unfreeze";
      };
  };

  # NOTE: defined here for shell integrations
  programs.fd = {
    enable = true;
  };

  programs.atuin = {
    enable = true;

    flags = [
      "--disable-up-arrow"
    ];
  };

  programs.carapace = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
  };

  programs.yazi = {
    enable = true;
  };

  programs.zoxide = {
    enable = true;
  };

  programs.skim = {
    enable = true;
  };

  programs.starship = {
    enable = true;

    settings = {
      add_newline = false;
    };
  };

  # TODO: add config
  programs.zellij = {
    enable = true;
  };

  programs.ghostty = {
    enable = true;

    settings = {
      command = "${lib.getExe pkgs.nushell}";
    };
  };

  programs.tofi = {
    enable = true;

    settings = {
      prompt-text = "> ";

      anchor = "top";
      width = "100%";
      height = 30;
      horizontal = true;
      outline-width = 0;
      border-width = 0;
      min-input-width = 120;
      result-spacing = 15;
      padding-top = 0;
      padding-bottom = 0;
      padding-left = 0;
      padding-right = 0;
    };
  };
}
