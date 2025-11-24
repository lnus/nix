# TEMP everything here should/will be moved
{pkgs, ...}: {
  home.packages = with pkgs; [
    mpv
    qbittorrent
    spotify
  ];
}
