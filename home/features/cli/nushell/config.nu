$env.PROMPT_COMMAND = {|| conch}
$env.PROMPT_COMMAND_RIGHT = {||}

def start_zellij [] {
  if 'ZELLIJ' not-in ($env | columns) and 'ZELLIJ_DISABLE' not-in ($env | columns) {
    if 'ZELLIJ_AUTO_ATTACH' in ($env | columns) and $env.ZELLIJ_AUTO_ATTACH {
      zellij attach -c
    } else {
      zellij
    }

    if 'ZELLIJ_AUTO_EXIT' in ($env | columns) and $env.ZELLIJ_AUTO_EXIT {
      exit
    }
  }
}

$env.ZELLIJ_AUTO_ATTACH = false;
$env.ZELLIJ_AUTO_EXIT = true;

start_zellij

if $nu.is-interactive and ($env.YAZI_ID? | default "" | is-empty) {
  yy
}
