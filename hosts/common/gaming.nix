{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    itch
    lutris
    wine
  ];
}
