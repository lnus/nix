# shellcheck shell=bash
# $vm is set by the nix wrapper
usage() {
  echo "usage: screenshot [-o dir] [-w wallpaper] [ref...]   (default: -o ./screenshots, ref HEAD)"
}

out=./screenshots
wallpaper=''
boot_timeout=90
while getopts o:w:h opt; do
  case $opt in
    o) out=$OPTARG ;;
    w) wallpaper=$(realpath "$OPTARG") ;;
    h) usage; exit 0 ;;
    *) usage >&2; exit 2 ;;
  esac
done
shift $((OPTIND - 1))
(($#)) || set -- HEAD

if [[ -t 1 ]]; then
  bold=$'\e[1m' dim=$'\e[2m' red=$'\e[31m' green=$'\e[32m' yellow=$'\e[33m' reset=$'\e[0m' clear=$'\r\e[K'
else
  bold='' dim='' red='' green='' yellow='' reset='' clear=''
fi

repo=$(git rev-parse --show-toplevel)
mkdir -p "$out"
out=$(realpath "$out")

elapsed() {
  local s=$((SECONDS - $1))
  if ((s >= 60)); then printf "%dm%02ds" $((s / 60)) $((s % 60)); else printf "%ds" "$s"; fi
}
pretty() { realpath --relative-base="$PWD" "$1"; }

# last stage the test script reached, from the driver log
stage() {
  local log=$1 s="starting vm"
  grep -q 'waiting for unit graphical.target' "$log" && s="booting"
  grep -q 'niri\.\*\.sock' "$log" && s="waiting for niri"
  grep -q "command -v noctalia" "$log" && s="setting up"
  grep -q 'spawn -- firefox' "$log" && s="opening firefox"
  grep -q 'spawn -- ghostty' "$log" && s="opening terminal"
  grep -q 'sending keys' "$log" && s="typing"
  grep -q 'grim ' "$log" && s="capturing"
  grep -q "notify-send" "$log" && s="shell popups"
  grep -q "theme-mode-set" "$log" && s="light mode"
  echo "$s"
}

# step <start> <msg>: rewrite the current line on a tty
step() { if [[ -n $clear ]]; then printf '%s  %s… %s%s%s' "$clear" "$2" "$dim" "$(elapsed "$1")" "$reset"; fi; }
ok() { printf '%s  %s✓%s %-10s %s%6s%s  %s\n' "$clear" "$green" "$reset" "$1" "$dim" "$2" "$reset" "${3-}"; }
fail() {
  printf '%s  %s✗%s %-10s %s%6s%s  %s\n' "$clear" "$red" "$reset" "$1" "$dim" "$2" "$reset" "see $(pretty "$3")"
  tail -n 12 "$3" | sed -e 's/\x1b\[[0-9;]*m//g' -e "s/^/    $dim│$reset /"
}

total=$SECONDS
failed=0
for ref in "$@"; do
  if ! rev=$(git rev-parse --verify --quiet "$ref^{commit}"); then
    printf '%s%s%s %snot a commit%s\n' "$bold" "$ref" "$reset" "$red" "$reset"
    failed=$((failed + 1))
    continue
  fi
  name=${ref//\//-}
  log=$out/$name.log
  : >"$log"
  printf '%s%s%s %s%s%s %s\n' "$bold" "$ref" "$reset" "$yellow" "$(git rev-parse --short "$rev")" "$reset" "$(git log -1 --format=%s "$rev")"

  args="flakeRef = \"git+file://$repo?rev=$rev\";"
  [[ -n $wallpaper ]] && args+=" wallpaper = $wallpaper;"

  start=$SECONDS
  nix build --impure --no-link --print-out-paths --log-format bar-with-logs \
    --expr "(import $vm { $args }).driver" >"$log.drv" 2>>"$log" &
  while kill -0 $! 2>/dev/null; do step "$start" "building"; sleep 1; done
  if ! wait $! || ! driver=$(<"$log.drv"); then
    fail "build" "$(elapsed "$start")" "$log"
    rm -f "$log.drv"
    failed=$((failed + 1))
    continue
  fi
  rm -f "$log.drv"
  ok "built" "$(elapsed "$start")"

  # niri won't render in software, so this runs outside the sandbox on the host gpu
  tmp=$(mktemp -d)
  for attempt in 1 2; do
    start=$SECONDS
    hung=0
    setsid "$driver/bin/nixos-test-driver" -o "$tmp" >>"$log" 2>&1 &
    pid=$!
    while kill -0 "$pid" 2>/dev/null; do
      s=$(stage "$log")
      step "$start" "$s"
      # boot normally takes ~10s; the guest sometimes freezes early and would sit out the 5 min timeout
      if [[ $s == booting ]] && ((SECONDS - start > boot_timeout)); then
        hung=1
        kill -- -"$pid" 2>/dev/null || true
      fi
      sleep 1
    done
    passed=0
    wait "$pid" && passed=1 && break
    ((hung && attempt == 1)) || break
    printf '%s  %s↻%s %-10s %s%6s%s  %s\n' "$clear" "$yellow" "$reset" "boot hung" "$dim" "$(elapsed "$start")" "$reset" "retrying"
    echo "=== boot hung, retrying ===" >>"$log"
  done
  if ((passed)); then
    shots=()
    for png in "$tmp"/*.png; do
      base=$(basename "$png" .png)
      dest=$out/$name.png
      [[ $base == desktop ]] || dest=$out/$name-$base.png
      mv "$png" "$dest"
      shots+=("$(pretty "$dest")")
    done
    ok "captured" "$(elapsed "$start")" "${shots[*]}"
  else
    fail "$(stage "$log")" "$(elapsed "$start")" "$log"
    failed=$((failed + 1))
  fi
  rm -rf "$tmp"
done

n=$#
if ((failed)); then
  printf '\n%s%d/%d failed%s in %s\n' "$red" "$failed" "$n" "$reset" "$(elapsed "$total")"
  exit 1
fi
printf '\n%s%d/%d done%s in %s → %s\n' "$green" "$n" "$n" "$reset" "$(elapsed "$total")" "$(pretty "$out")"
