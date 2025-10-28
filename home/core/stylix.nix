# QUESTION: Should this be in hosts/common?
# It does affect system as well, but also home.
# Here might be nicer, since it can be defined per-user.
# (It still can, no matter the location, but... ykwim)
{
  inputs,
  pkgs,
  lib,
  ...
}: {
  imports = [inputs.stylix.homeModules.stylix];

  # FIX: Make theme adjustable
  # FIX: user based firefox profile
  stylix = {
    enable = lib.mkDefault true; # TODO: default to false
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";
    targets.firefox.profileNames = ["linus"];
  };
}
