# QUESTION: Should this be in hosts/common?
# It does affect system as well, but also home.
# Here might be nicer, since it can be defined per-user.
# (It still can, no matter the location, but... ykwim)
{
  inputs,
  pkgs,
  ...
}: {
  # FIX: Might move this since I use/will use it in
  # other modules to pull colors, ex. noctalia.nix
  imports = [inputs.stylix.homeModules.stylix];

  # FIX: Make theme adjustable
  # FIX: user based firefox profile
  stylix = {
    enable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";
    targets.firefox.profileNames = ["linus"];
  };
}
