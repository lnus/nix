{...}: {
  home.shell.enableBashIntegration = true;

  home.shellAliases = {
    la = "ls --all";
    ll = "ls --long";
    lla = "ls --long --all";
    sl = "ls";
    e = "hx";
    v = "hx";
    mv = "mv --verbose";
    rm = "rm --verbose";
    cp = "cp --verbose --recursive --progress";
  };

  programs.bash.enable = true;

  imports = [./nushell];
}
