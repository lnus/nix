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
# the cursor shape already shows the vi mode
$env.PROMPT_INDICATOR = ""
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""

$env.config.table.mode = "light"
$env.config.table.index_mode = "auto"
$env.config.table.missing_value_symbol = "—"
# otherwise externals like `nix` never get shape_external_resolved
$env.config.highlight_resolved_externals = true

# ANSI names only, so colours follow the terminal's light/dark theme
$env.config.color_config = {
    separator: dark_gray
    row_index: dark_gray
    header: { attr: b }
    leading_trailing_space_bg: { attr: n }
    empty: dark_gray
    nothing: dark_gray
    hints: dark_gray

    bool: magenta
    int: default
    float: default
    filesize: default
    duration: default
    datetime: default
    range: default
    string: default
    glob: default
    cell-path: default
    list: default
    record: default
    block: default
    closure: default
    binary: default
    semver: default
    semver-range: default
    binary_null_char: dark_gray
    binary_printable: default
    binary_whitespace: dark_gray
    binary_ascii_other: dark_gray
    binary_non_ascii: dark_gray

    search_result: { fg: black, bg: magenta }
    selection: { attr: r }
    selection_cursor: { attr: n }

    shape_internalcall: magenta_bold
    shape_external_resolved: magenta_bold
    shape_external: default
    shape_keyword: magenta
    shape_string: green
    shape_raw_string: green
    shape_string_interpolation: green
    shape_glob_interpolation: green
    shape_flag: default
    shape_externalarg: default
    shape_filepath: default
    shape_directory: default
    shape_globpattern: default
    shape_variable: default
    shape_vardecl: default
    shape_int: default
    shape_float: default
    shape_bool: magenta
    shape_nothing: dark_gray
    shape_datetime: default
    shape_binary: default
    shape_range: default
    shape_operator: dark_gray
    shape_pipe: dark_gray
    shape_redirection: dark_gray
    shape_block: default
    shape_closure: default
    shape_signature: default
    shape_list: default
    shape_record: default
    shape_table: default
    shape_literal: default
    shape_custom: default
    shape_match_pattern: default
    shape_matching_brackets: { attr: u }
    shape_garbage: { fg: red, attr: u }
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
alias lg = lazygit

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

use scripts/flake-bump.nu
