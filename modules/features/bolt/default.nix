{self, ...}: {
  perSystem = {pkgs, ...}: {
    packages.boltLauncher = pkgs.symlinkJoin {
      name = "bolt-launcher-wrapped";
      paths = [pkgs.bolt-launcher];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram $out/bin/bolt-launcher \
          --set TZ ":Europe/Stockholm" \
          --set XRE_PROFILE_PATH "/home/linus/.config/mozilla/firefox/linus" \
          --set _JAVA_AWT_WM_NONREPARENTING 1
      '';
    };
  };

  flake.nixosModules.boltLauncher = {pkgs, ...}: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.boltLauncher
    ];
  };
}
