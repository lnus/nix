{pkgs, ...}: {
  programs.firefox = {
    enable = true;

    profiles.linus = {
      isDefault = true;

      settings = {
        "browser.startup.homepage" = "about:home";
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
      };
    };
  };
}
