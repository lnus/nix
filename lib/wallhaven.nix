{pkgs, ...}: {
  fetch = {
    id,
    ext,
    hash,
  }:
    pkgs.fetchurl {
      url = "https://w.wallhaven.cc/full/${builtins.substring 0 2 id}/wallhaven-${id}.${ext}";
      inherit hash;
    };
}
