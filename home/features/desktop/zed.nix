{
  config,
  lib,
  ...
}: let
  cfg = config.features.desktop.zed;
in {
  options.features.desktop.zed = {
    enable = lib.mkEnableOption "enable zed editor";

    nvidia = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Apply Nvidia Wayland workaround in the desktop entry";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor.enable = true;

    # It is possible to work around this by just resizing the window,
    # but unsetting WAYLAND_DISPLAY is more comfortable.
    #
    # Keep track of these issues and remove fix if resolved:
    # https://github.com/zed-industries/zed/pull/46758
    # https://github.com/zed-industries/zed/issues/39097
    # https://github.com/YaLTeR/niri/issues/2335
    xdg.desktopEntries = lib.mkIf cfg.nvidia {
      "dev.zed.Zed" = {
        name = "Zed";
        genericName = "Text Editor";
        comment = "A high-performance, multiplayer code editor.";
        type = "Application";
        startupNotify = true;
        exec = "env -u WAYLAND_DISPLAY zeditor %U";
        icon = "zed";
        terminal = false;
        categories = ["Utility" "TextEditor" "Development" "IDE"];
        mimeType = [
          "text/plain"
          "application/x-zerosize"
          "x-scheme-handler/zed"
        ];
        actions = {
          NewWorkspace = {
            name = "Open a new workspace";
            exec = "zeditor --new %U";
          };
        };
      };
    };
  };
}
