{
  pkgs,
  lib,
  ...
}: {
  programs.ghostty = {
    enable = true;
    settings = {
      command = "${lib.getExe pkgs.nushell}";
      theme = "noctalia";
    };
  };
}
