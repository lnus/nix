{
  pkgs,
  config,
  ...
}: let
  colors =
    if (config.lib.stylix.colors or null) != null
    then config.lib.stylix.colors
    else {
      base00 = "19171a";
      base01 = "201e21";
    };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    profiles.linus = {
      isDefault = true;

      userChrome = builtins.readFile (
        pkgs.substitute {
          src = ./userChrome.css;
          substitutions = [
            "--subst-var-by"
            "base00"
            "#${colors.base00}"
            "--subst-var-by"
            "base01"
            "#${colors.base01}"
          ];
        }
      );
      userContent = builtins.readFile ./userContent.css;

      search = {
        default = "ddg";
        force = true;
      };

      extensions.packages = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        sponsorblock
        reddit-enhancement-suite
      ];

      settings = {
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;

        "browser.startup.homepage" = "about:newtab";
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;

        # https://github.com/Krutonium/NewNix/blob/master/user/krutonium-hm-extras/firefox.nix
        "extensions.pocket.enabled" = false;

        "signon.rememberSignons" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
        "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
        "browser.newtabpage.activity-stream.feeds.topsites" = false;
        "browser.tabs.groups.enabled" = false;

        "browser.compactmode.show" = true;
        "browser.uidensity" = "1";

        "browser.ml.enabled" = false;
        "browser.ml.chat.enabled" = false;
        "browser.ml.chat.menu" = false;
        "browser.ml.chat.shortcuts" = false;
        "browser.ml.chat.shortcuts.custom" = false;
        "extensions.ml.enabled" = false;
        "browser.ml.chat.page" = false;
        "browser.ml.chat.page.footerBadge" = false;
        "browser.ml.chat.page.menuBadge" = false;
        "browser.mk.linkPreview.enable" = false;
        "browser.ml.chat.sidebar" = false;
        "browser.ml.chat.onboard.config" = "fuck you";
        "browser.ml.checkForMemory" = false;
        "browser.ml.linkPreview.shift" = false;
        "browser.ml.linkPreview.onboardingTimes" = 0;
        "browser.urlbar.trimURLs" = false;
      };
    };
  };
}
