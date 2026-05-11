# See https://code.m3ta.dev/m3tam3re/nixcfg/src/branch/video18/overlays/default.nix for reference
{inputs, ...}: {
  additions = final: _prev: import ../pkgs {pkgs = final;};

  stable = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.stdenv.hostPlatform.system;
      config.allowUnfree = true;
    };
  };

  # TODO: Wire this properly!!!!!
  liLib = final: _prev: {
    liLib = import ../lib {pkgs = final;};
  };

  modifications = final: prev: {
    # https://github.com/NixOS/nixpkgs/issues/513245#issuecomment-4320293674
    openldap = prev.openldap.overrideAttrs {
      doCheck = !prev.stdenv.hostPlatform.isi686;
    };
  };
}
