{
  # TODO: fix with options, ie, make a
  # - compositor.nix/wm.nix
  # - shell.nix
  # - greeter.nix (done, use as example)
  #
  # This could also apply to stuff like gaming etc? Rather than
  # importing tons of modules we could orchestrate it from here
  # and set options in hosts. I think I like that architecture
  # more.
  imports = [
    ./niri.nix
    ./greeter.nix
    ./noctalia.nix
  ];
}
