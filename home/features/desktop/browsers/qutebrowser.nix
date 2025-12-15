{
  lib,
  config,
  ...
}: let
  cfg = config.features.desktop.browsers.qutebrowser; # TODO: move options into browser.nix
in {
  options.features.desktop.browsers.qutebrowser.enable = lib.mkEnableOption "enable qutebrowser";

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      programs.qutebrowser.enable = true;
    })
  ];
}
