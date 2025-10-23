{lib, ...}: {
  time.timeZone = "Europe/Stockholm";
  i18n.defaultLocale = "en_US.UTF-8";

  console.keyMap = "us";

  # backwards comp, might need
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
}
