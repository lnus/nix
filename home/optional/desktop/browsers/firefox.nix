{
  pkgs,
  config,
  ...
}: let
  colors =
    if (config.lib.stylix.colors or null) != null
    then config.lib.stylix.colors
    else {
      # TODO: consider doing this at a higher level,
      # defining "colorScheme" global-ish derived from either
      # stylix or default fallback
      #
      # Falling back to charcoal-dark for now
      # https://github.com/tinted-theming/schemes/blob/spec-0.11/base16/charcoal-dark.yaml
      base00 = "0f0b05";
      base01 = "231b0e";
      base02 = "2a2012";
      base03 = "57462c";
      base04 = "a88c62";
      base05 = "c3a983";
      base06 = "dec8a7";
      base07 = "231b0e";
      base08 = "a88c62";
      base09 = "dec8a7";
      base0A = "dec8a7";
      base0B = "dec8a7";
      base0C = "dec8a7";
      base0D = "c3a983";
      base0E = "a88c62";
      base0F = "876e48";
    };

  userChrome_font =
    if (config.stylix.fonts.monospace.name or null) != null
    then config.stylix.fonts.monospace.name
    else "DejaVu Sans Mono"; # not pretty, but should werk as fallback
in {
  xdg.configFile."tridactyl/blank.html".text = ''
    <!DOCTYPE html>
    <html>
    <head>
      <title>New Tab</title>
      <style>
      body {
        background-color: #${colors.base00};
        margin: 0;
        height: 100vh;
      }
      </style>
    </head>
    <body></body>
    </html>
  '';

  # pulling from dracula as a base is strange-ish but it looks nice
  # TODO consider writing a style manually
  xdg.configFile."tridactyl/themes/stylix.css".text =
    builtins.readFile "${
      builtins.fetchGit {
        url = "https://github.com/dracula/tridactyl";
        ref = "main";
        rev = "4c988ef06076566e86d2c1e0d6c825e8f8fdad60";
      }
    }/dracula.css"
    + ''
      :root {
        --bg: #${colors.base00};
        --currentline: #${colors.base01};
        --fg: #${colors.base05};
        --comment: #${colors.base03};
        --cyan: #${colors.base0C};
        --green: #${colors.base0B};
        --orange: #${colors.base09};
        --pink: #${colors.base0E};
        --purple: #${colors.base0D};
        --red: #${colors.base08};
        --yellow: #${colors.base0A};
        --font: ${userChrome_font}, monospace;
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
          --tab-active-bg-color: #${colors.base02};
          --tab-inactive-bg-color: #${colors.base01};
          --tab-active-fg-fallback-color: #${colors.base05};
          --tab-inactive-fg-fallback-color: #${colors.base04};
          --urlbar-focused-bg-color: #${colors.base02};
          --urlbar-not-focused-bg-color: #${colors.base00};
          --toolbar-bgcolor: #${colors.base01} !important;
          --tab-font: '${userChrome_font}';
          --urlbar-font: '${userChrome_font}';
        }
      '';

      search = {
        default = "ddg";
        force = true;
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
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
}
