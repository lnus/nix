{ self, ... }: {
  perSystem = { pkgs, ... }: {
    # nvidia-smi comes from the host's driver, not the store
    packages.gpu-log = pkgs.writeShellApplication {
      name = "gpu-log";
      runtimeInputs = [ pkgs.coreutils ];
      text = ''
        usage() {
          echo "usage: gpu-log [-n NAME] [-i SECONDS] [-d DIR] [-- COMMAND...]"
          echo "Log NVIDIA GPU stats (VRAM, load, temp, clocks, power, throttle reasons) to a CSV."
          echo "Without COMMAND: until Ctrl+C. With COMMAND: for as long as it runs."
          echo "  -n NAME     file is NAME_gpu_<date>_<time>.csv (default gpu_<date>_<time>.csv)"
          echo "  -i SECONDS  sample interval (default 1)"
          echo "  -d DIR      output dir (default ~/.local/share/mangohud/logs)"
        }

        name=""
        interval=1
        dir="$HOME/.local/share/mangohud/logs"
        while getopts n:i:d:h opt; do
          case $opt in
            n) name="''${OPTARG}_" ;;
            i) interval=$OPTARG ;;
            d) dir=$OPTARG ;;
            h) usage; exit 0 ;;
            *) usage >&2; exit 2 ;;
          esac
        done
        shift $((OPTIND - 1))

        mkdir -p "$dir"
        file="$dir/''${name}gpu_$(date +%F_%H-%M-%S).csv"
        query=timestamp,memory.used,memory.total,utilization.gpu,temperature.gpu,clocks.gr,clocks.mem,power.draw,clocks_event_reasons.active

        # stdbuf: nvidia-smi's own -f only writes on exit
        if [ $# -eq 0 ]; then
          echo "logging to $file, Ctrl+C to stop" >&2
          exec stdbuf -oL nvidia-smi --query-gpu="$query" --format=csv -l "$interval" >"$file"
        fi

        stdbuf -oL nvidia-smi --query-gpu="$query" --format=csv -l "$interval" >"$file" &
        logger=$!
        # exec keeps this PID, so the watcher sees COMMAND exit and stops the logger
        (
          while kill -0 $$ 2>/dev/null; do sleep 1; done
          kill "$logger" 2>/dev/null
        ) &
        exec "$@"
      '';
    };
  };

  flake.nixosModules.gpu-log = { pkgs, ... }: {
    environment.systemPackages = [ self.packages.${pkgs.stdenv.hostPlatform.system}.gpu-log ];
  };
}
