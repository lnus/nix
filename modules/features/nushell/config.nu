$env.PROMPT_COMMAND = {|| starship prompt }
$env.PROMPT_COMMAND_RIGHT = {||

}

$env.ZELLIJ_AUTO_ATTACH = false
$env.ZELLIJ_AUTO_EXIT = true
$env.YAZI_AUTO_START = false

$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.buffer_editor = "hx"
$env.config.cursor_shape = {
    vi_insert: "line"
    vi_normal: "block"
}

alias la = ls --all
alias ll = ls --long
alias lla = ls --long --all
alias sl = ls
alias e = hx
alias v = hx
alias mv = mv --verbose
alias rm = rm --verbose
alias cp = cp --verbose --recursive --progress
alias yy = yazi
alias fg = job unfreeze

$env.config.keybindings = [
    {
        event: {cmd: "yy", send: "executehostcommand"}
        keycode: "char_e"
        mode: [
            "vi_insert"
            "vi_normal"
        ]
        modifier: "Control"
        name: "launch_yazi"
    }
]

$env.config.hooks.env_change.PWD = [
    {||
        direnv export json | from json | default {} | load-env
    }
]

if ($nu.is-interactive
    and ($env.YAZI_AUTO_START? | default false)
    and ($env.YAZI_ID? | default "" | is-empty)
    and 'ZELLIJ' not-in ($env | columns)) {
    yy
}

source "~/.zoxide.nu"
