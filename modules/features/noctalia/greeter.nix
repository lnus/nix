{self, ...}: {
  # greetd + noctalia-greeter, styled to match the shell (see ./default.nix).
  # Wallpaper isn't set here: it lives under /home, so it comes over via
  # the shell's Settings → Security → Noctalia Greeter → Sync / Auto-Sync.
  flake.nixosModules.noctalia-greeter = {
    config,
    lib,
    pkgs,
    ...
  }: let
    cfg = config.services.displayManager.noctalia-greeter;
  in {
    services.displayManager.noctalia-greeter = {
      enable = true;
      passwordlessSyncUsers = ["linus"];

      # sets settings.cursor.theme/path
      cursorTheme = {
        inherit (self.theme.cursor) name;
        package = self.theme.cursor.package pkgs;
      };

      settings = {
        session.default = "niri";
        user.default = "linus";

        appearance = {
          scheme = "Gruvbox";
          theme_mode = "dark";
          corner_radius_scale = 0.0;
          font_family = self.theme.fonts.sans;
          hide_logo = true;
        };

        cursor.size = self.theme.cursor.size;
        keyboard.layout = config.services.xserver.xkb.layout;
      };
    };

    # nixpkgs' module doesn't point the greeter at the generated session
    # .desktop files, so niri wouldn't show up in the session picker
    services.greetd.settings.default_session.command = lib.concatStringsSep " " [
      "${lib.getExe' pkgs.coreutils "env"}"
      "XDG_DATA_DIRS=${config.services.displayManager.sessionData.desktops}/share"
      "${lib.getExe' cfg.package "noctalia-greeter-session"}"
      (lib.escapeShellArgs cfg.extraArgs)
    ];
  };
}
