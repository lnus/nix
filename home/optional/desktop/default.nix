{lib, ...}: {
  # TODO: this does nothing right now, but maybe some day
  options.optional.desktop.environment = lib.mkOption {
    type = lib.types.enum ["niri"];
    default = "niri";
    description = "Which desktop environment to use";
  };

  imports = [
    ./discord.nix
    ./ghostty.nix
    ./noctalia.nix
    ./hypridle.nix
    ./browsers
    ./niri
    ./misc
  ];
}
