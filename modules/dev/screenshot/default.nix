{
  perSystem =
    { pkgs, ... }:
    {
      # nix run .#screenshot -- [-o dir] [-w wallpaper] [ref...]
      packages.screenshot = pkgs.writeShellApplication {
        name = "screenshot";
        runtimeInputs = [
          pkgs.git
          pkgs.nix
          pkgs.util-linux
        ];
        text = ''
          vm=${./.}/_vm.nix
          ${builtins.readFile ./screenshot.sh}
        '';
      };
    };
}
