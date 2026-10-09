{ self, ... }: {
  flake.nixosModules.fcitx5 =
    {
      config,
      options,
      lib,
      pkgs,
      ...
    }:
    let
      fcitx5 = config.i18n.inputMethod.package;
      layout = "${self.keyboard.layout}-${self.keyboard.variant}";
    in
    {
      config = lib.mkMerge [
        {
          i18n.inputMethod = {
            enable = true;
            type = "fcitx5";
            fcitx5 = {
              waylandFrontend = true;
              addons = [ pkgs.fcitx5-mozc ];
              settings = {
                globalOptions = {
                  "Hotkey/TriggerKeys"."0" = "Super+space";
                  Behavior.ShareInputState = "All";
                };
                inputMethod = {
                  GroupOrder."0" = "Default";
                  "Groups/0" = {
                    Name = "Default";
                    "Default Layout" = layout;
                    DefaultIM = "mozc";
                  };
                  "Groups/0/Items/0" = {
                    Name = "keyboard-${layout}";
                    Layout = "";
                  };
                  "Groups/0/Items/1" = {
                    Name = "mozc";
                    Layout = "";
                  };
                };
              };
            };
          };
        }
        (lib.optionalAttrs (options.programs.niri ? wrapper) {
          programs.niri.wrapper = {
            settings.spawn-at-startup = [
              [
                "${fcitx5}/bin/fcitx5"
                "-d"
              ]
            ];

            binds."Mod+Space" = _: {
              props.hotkey-overlay-title = "Toggle Japanese Input";
              content.spawn = [
                "${fcitx5}/bin/fcitx5-remote"
                "-t"
              ];
            };
          };
        })
      ];
    };
}
