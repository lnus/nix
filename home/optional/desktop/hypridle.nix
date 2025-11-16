{
  # TEMP
  # FIX depends on both niri and noctalia.
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        before_sleep_cmd = "noctalia-shell ipc call lockScreen lock";
      };

      listener = [
        {
          timeout = 600;
          on-timeout = "noctalia-shell ipc call lockScreen lock";
        }
        {
          timeout = 601;
          on-timeout = "niri msg action power-off-monitors";
        }
      ];
    };
  };
}
