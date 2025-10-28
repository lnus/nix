{lib, ...}: {
  # TODO: make this do something
  options.optional.desktop.enable = lib.mkEnableOption "desktop environment";

  # FIX: this should probably not be defualt
  imports = [./desktop];
}
