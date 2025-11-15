{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;

    profiles.linus = {
      isDefault = true;

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
        "browser.startup.homepage" = "about:home";
        "privacy.donottrackheader.enabled" = true;
        "privacy.trackingprotection.enabled" = true;
      };
    };
  };
}
