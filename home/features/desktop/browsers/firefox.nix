# TODO: make more generic.
# this is probably the messiest file of them all.
# profiles, home dir, tridactyl, etc.
{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.features.desktop.browsers.firefox;
in {
  options.features.desktop.browsers.firefox.enable = lib.mkEnableOption "enable firefox";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.firefox = {
        enable = true;
        configPath = "${config.xdg.configHome}/mozilla/firefox";

        profiles.linus = {
          isDefault = true;

          search = {
            default = "ddg";
            force = true;
          };

          # FIXME fugly
          extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
            ublock-origin
            sponsorblock
            reddit-enhancement-suite
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
