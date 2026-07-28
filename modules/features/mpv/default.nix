{...}: {
  flake.nixosModules.mpv = {pkgs, ...}: {
    environment.systemPackages = with pkgs; [
      mpv
    ];
  };
}
