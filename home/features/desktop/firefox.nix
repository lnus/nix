# TODO: make more generic.
# this is probably the messiest file of them all.
# profiles, home dir, tridactyl, etc.
{
  inputs,
  lib,
  pkgs,
  config,
  stylixLib,
  ...
}: let
  cfg = config.features.desktop.firefox; # Turn into a browser.nix thingy later maybe
  c = stylixLib.mkBase16 config;
  isStylix = stylixLib.isStylix config;
  font_mono = stylixLib.getFont config;
in {
  options.features.desktop.firefox.enable = lib.mkEnableOption "enable firefox";

  config = lib.mkMerge [
    # Currently, firefox theming is disabled in stylix. But...
    # I could change that in the future. Leaving this here.
    (lib.mkIf (cfg.enable && isStylix) {
      stylix.targets.firefox.profileNames = ["linus"];
    })

    (lib.mkIf cfg.enable {
      xdg.configFile."tridactyl/blank.html".text = ''
        <!DOCTYPE html>
        <html>
        <head>
          <title>New Tab</title>
          <style>
          body {
            background-color: ${c.hex.base00};
            margin: 0;
            height: 100vh;
          }
          </style>
        </head>
        <body></body>
        </html>
      '';

      xdg.configFile."tridactyl/themes/stylix.css".text =
        builtins.readFile "${
          builtins.fetchGit {
            url = "https://github.com/tridactyl/tridactyl";
            ref = "master";
            rev = "030ef4d2ab8e20d36a5db19074c7e904a1963344";
          }
        }/src/static/themes/quake/quake.css"
        + ''
          :root {
            --tridactyl-bg: ${c.hex.base00};
            --tridactyl-fg: ${c.hex.base05};
            --tridactyl-scrollbar-color: var(--tridactyl-fg);

            --tridactyl-hintspan-fg: var(--tridactyl-bg);
            --tridactyl-hintspan-bg: var(--tridactyl-fg);

            --tridactyl-hint-active-fg: var(--tridactyl-fg);
            --tridactyl-hint-active-bg: rgba(0,0,0,0.3);
            --tridactyl-hint-active-outline: none;
            --tridactyl-hint-bg: rgba(0,0,0,0.3);
            --tridactyl-hint-outline: none;
          }
        '';

      xdg.configFile."tridactyl/tridactylrc".text = ''
        unbind G
        bind ge scrollto 100

        set newtab about:blank
        set editorcmd ghostty -e hx
        set theme stylix
      '';

      programs.firefox = {
        enable = true;
        package = pkgs.firefox.override {
          nativeMessagingHosts = [
            pkgs.tridactyl-native
          ];
        };

        profiles.linus = {
          isDefault = true;

          userChrome = ''
            @import "${
              builtins.fetchGit {
                url = "https://github.com/Dook97/firefox-qutebrowser-userchrome";
                ref = "master";
                rev = "12598c1371a70fa230844f681b9a904eb9eb3546";
              }
            }/userChrome.css";

            :root {
              --tab-active-bg-color: ${c.hex.base02};
              --tab-inactive-bg-color: ${c.hex.base01};
              --tab-active-fg-fallback-color: ${c.hex.base05};
              --tab-inactive-fg-fallback-color: ${c.hex.base04};
              --urlbar-focused-bg-color: ${c.hex.base02};
              --urlbar-not-focused-bg-color: ${c.hex.base00};
              --toolbar-bgcolor: ${c.hex.base01} !important;
              --tab-font: '${font_mono.name}';
              --urlbar-font: '${font_mono.name}';
            }
          '';

          search = {
            default = "ddg";
            force = true;
          };

          # FIXME fugly
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            sponsorblock
            reddit-enhancement-suite
            tridactyl
          ];

          settings = {
            # Adapted from: https://github.com/arkenfox/user.js/
            # === TELEMETRY ===
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.server" = "data:,";
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.normandy.enabled" = false;
            "app.normandy.api_url" = "";

            # === POCKET ===
            "extensions.pocket.enabled" = false;

            # === AI/ML FEATURES ===
            "browser.ml.enable" = false;
            "browser.ml.chat.enabled" = false;
            "browser.ml.chat.sidebar" = false;

            # === NEW TAB CLEANUP ===
            "browser.newtabpage.activity-stream.feeds.telemetry" = false;
            "browser.newtabpage.activity-stream.telemetry" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.showSponsored" = false;
            "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;

            # === PRIVACY ===
            "privacy.trackingprotection.enabled" = true;
            "dom.security.https_only_mode" = true;
            "browser.contentblocking.category" = "strict";

            # === ANNOYANCES ===
            "browser.shell.checkDefaultBrowser" = false;
            "browser.discovery.enabled" = false;
            "browser.search.suggest.enabled" = false; # stops sending keystrokes to search engine

            # === MISC ===
            "browser.startup.homepage" = "file://${config.home.homeDirectory}/.config/tridactyl/blank.html";
            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "browser.compactmode.show" = true;
            "browser.uidensity" = 1;
            "browser.urlbar.trimURLs" = false;
            "signon.rememberSignons" = false;
          };
        };
      };
    })
  ];
}
