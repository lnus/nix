{
  self,
  moduleWithSystem,
  ...
}: {
  flake.nixosModules.video = moduleWithSystem ({pkgs, ...}: let
    modules = with self.nixosModules; [
      obs-studio
      mpv
    ];
  in {
    imports = modules;
    environment.systemPackages = with pkgs; [
      losslesscut
    ];
  });
}
