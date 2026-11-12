# A host's config at some git ref, booted with a type specimen in firefox and a
# terminal beside it. Only the driver builds in the sandbox; run it on the host.
{
  flakeRef,
  host ? "miku",
  user ? "linus",
  width ? 2560,
  height ? 1440,
  # typed into the terminal
  commands ? [
    "ls /etc | first 6"
    "fastfetch"
  ],
  wallpaper ? null,
}:
let
  flake = builtins.getFlake flakeRef;
  pkgs = flake.inputs.nixpkgs.legacyPackages.x86_64-linux;
  lib = pkgs.lib;
  wallpaper' =
    if wallpaper != null then
      builtins.path { path = wallpaper; }
    else
      pkgs.nixos-artwork.wallpapers.gradient-grey.gnomeFilePath;

  # fresh profile without first-run tabs
  firefoxPrefs = pkgs.writeText "user.js" ''
    user_pref("browser.aboutwelcome.enabled", false);
    user_pref("browser.startup.homepage_override.mstone", "ignore");
    user_pref("browser.shell.checkDefaultBrowser", false);
    user_pref("datareporting.policy.dataSubmissionPolicyBypassNotification", true);
    user_pref("trailhead.firstrun.didSeeAboutWelcome", true);
    user_pref("browser.toolbars.bookmarks.visibility", "never");
  '';
in
pkgs.testers.runNixOSTest {
  name = "screenshot-${host}";
  node.pkgsReadOnly = false;

  nodes.machine =
    { config, pkgs, ... }:
    {
      imports = [ flake.nixosModules."${host}Configuration" ];

      virtualisation = {
        memorySize = 8192;
        cores = 8;
        # no live weather or other fetches, so shots only differ by config
        restrictNetwork = true;
        # qemu_test has no opengl
        qemu.package = lib.mkForce pkgs.qemu;
        qemu.options = [
          "-vga none"
          "-device virtio-vga-gl,xres=${toString width},yres=${toString height}"
          "-display egl-headless,gl=on"
        ];
      };

      services.xserver.videoDrivers = lib.mkForce [ ];
      hardware.nvidia.package = lib.mkForce null;
      boot.initrd.kernelModules = lib.mkForce [ "virtio_gpu" ];
      boot.consoleLogLevel = lib.mkForce 7;
      # suspect in an early-boot freeze, and never on screen anyway
      boot.plymouth.enable = lib.mkForce false;

      # skip the greeter
      services.greetd.settings.initial_session = {
        inherit user;
        command = "${config.programs.niri.package}/bin/niri-session";
      };

      environment.systemPackages = [
        pkgs.grim
        pkgs.fastfetch
        pkgs.fontconfig
        pkgs.libnotify
      ];

      # first-boot popups: autologin has no password to create the keyring with,
      # and noctalia shows its setup wizard until this marker exists
      services.gnome.gnome-keyring.enable = lib.mkForce false;
      systemd.tmpfiles.rules =
        map (d: "d /home/${user}/${d} 0755 ${user} users -") [
          ".local"
          ".local/state"
          ".local/state/noctalia"
        ]
        ++ [
          "f /home/${user}/.local/state/noctalia/.setup-complete 0644 ${user} users -"
          "d /tmp/screenshot-firefox 0755 ${user} users -"
          "C /tmp/screenshot-firefox/user.js 0644 ${user} users - ${firefoxPrefs}"
        ];
    };

  testScript = ''
    import shlex
    import time

    def env():
        sock = machine.succeed(f"ls {rt}/niri.*.sock").strip()
        display = sock.removeprefix(f"{rt}/niri.").split(".")[0]
        return [
            "env",
            f"XDG_RUNTIME_DIR={rt}",
            f"WAYLAND_DISPLAY={display}",
            f"NIRI_SOCKET={sock}",
            f"DBUS_SESSION_BUS_ADDRESS=unix:path={rt}/bus",
        ]

    def user_cmd(*argv):
        return f"su ${user} -s /bin/sh -c {shlex.quote(shlex.join(env() + list(argv)))}"

    def as_user(*argv):
        return machine.succeed(user_cmd(*argv))

    def wait_for_window(app_id):
        machine.wait_until_succeeds(
            f"{user_cmd('niri', 'msg', 'windows')} | grep -q 'App ID: \"{app_id}\"'",
            timeout=60,
        )

    machine.wait_for_unit("graphical.target")
    rt = "/run/user/" + machine.succeed("id -u ${user}").strip()
    machine.wait_until_succeeds(f"ls {rt}/niri.*.sock", timeout=180)
    # let the shell and its startup animations settle
    machine.sleep(15)

    noctalia = machine.execute("command -v noctalia")[0] == 0
    if noctalia:
        as_user("noctalia", "msg", "wallpaper-set", "${wallpaper'}")

    fonts = {
        name: machine.succeed(f"fc-match -f '%{{family[0]}}' {name}").strip()
        for name in ["sans-serif", "serif", "monospace"]
    }
    machine.succeed(
        "sed"
        f" -e 's|@sans@|{fonts['sans-serif']}|'"
        f" -e 's|@serif@|{fonts['serif']}|'"
        f" -e 's|@mono@|{fonts['monospace']}|'"
        " ${./specimen.html} > /tmp/specimen.html && chmod 644 /tmp/specimen.html"
    )

    spawn = ["niri", "msg", "action", "spawn", "--"]
    as_user(*spawn, "firefox", "--no-remote", "--profile", "/tmp/screenshot-firefox", "file:///tmp/specimen.html")
    wait_for_window("firefox")
    as_user(*spawn, "ghostty")
    wait_for_window("com.mitchellh.ghostty")
    machine.sleep(3)
    ${lib.concatMapStrings (cmd: ''
      machine.send_chars(${builtins.toJSON "${cmd}\n"})
    '') commands}
    machine.sleep(8)
    as_user("grim", "/tmp/desktop.png")
    machine.copy_from_machine("/tmp/desktop.png", "")

    # the shell's popups over the same desktop; the control center opens where
    # the osd shows (top center by default), so it gets its own shot
    if noctalia:
        as_user("notify-send", "-a", "nix", "-i", "nix-snowflake", "Build finished", "miku is ready to switch, 3 packages changed")
        machine.sleep(1)
        as_user("noctalia", "msg", "osd-show", '{"icon": "volume-high", "value": "65%", "progress": 0.65}')
        time.sleep(0.5)
        as_user("grim", "/tmp/shell.png")
        machine.copy_from_machine("/tmp/shell.png", "")

        as_user("noctalia", "msg", "panel-open", "control-center")
        machine.sleep(1)
        as_user("grim", "/tmp/control.png")
        machine.copy_from_machine("/tmp/control.png", "")
  '';
}
