# Inspiration from:
# https://github.com/Misterio77/nix-config/blob/main/home/gabriel/features/helix/default.nix
# This is very messy and slightly vibecoded
{c}: let
  b = c.hex;

  # Map reference theme (amberwood) palette names -> Base16 slots.
  bg = b.base00;
  gray01 = b.base01;
  gray02 = b.base02;
  gray03 = b.base03;
  gray04 = b.base04;
  gray06 = b.base04; # no perfect match
  fg = b.base05;
  white = b.base06;
  bright_white = b.base07;

  red = b.base08;
  green = b.base0B;
  bright_green = b.base0B;

  yellow = b.base0A;
  blue = b.base0D;
  bright_blue = b.base0D;

  magenta = b.base0E;
  cyan = b.base0C;
  bright_cyan = b.base0C;

  comment = b.base03;

  # “semantic” names from reference theme (just aliases)
  function = yellow;
  support_function = b.base04;
  constant = b.base09;
  string = green;
  tag = b.base04;
  keyword = magenta;
  namespace = magenta;
  numeric = b.base09;
  status_line_fg = yellow;
  operator = fg;
  softwrap = b.base03;
  conditional = b.base04;

  cursor = b.base07; # strong cursor
in {
  # --- Syntax
  "attribute" = {
    fg = blue;
    modifiers = ["italic"];
  };
  "ui.virtual.wrap" = softwrap;

  "keyword" = keyword;
  "keyword.control.conditional" = {
    fg = conditional;
    modifiers = ["italic"];
  };
  "keyword.directive" = magenta;

  "namespace" = {
    fg = namespace;
    modifiers = ["italic"];
  };

  "punctuation" = gray06;
  "punctuation.delimiter" = gray06;

  "operator" = operator;
  "special" = yellow;

  "variable" = {fg = fg;};
  "variable.builtin" = bright_blue;
  "variable.parameter" = {
    fg = white;
    modifiers = ["italic"];
  };
  "variable.other.member" = white;

  "type" = bright_blue;
  "type.builtin" = magenta;
  "type.enum.variant" = magenta;

  "constructor" = yellow;

  "function" = {
    fg = function;
    modifiers = ["italic"];
  };
  "function.macro" = bright_cyan;
  "function.builtin" = support_function;

  "tag" = tag;
  "comment" = {
    fg = comment;
    modifiers = ["italic"];
  };

  "string" = string;
  "string.regexp" = green;
  "string.special" = yellow;

  "constant" = constant;
  "constant.builtin" = yellow;
  "constant.numeric" = numeric;
  "constant.character.escape" = cyan;

  "label" = yellow;

  # --- Markup
  "markup.heading.marker" = {fg = gray06;};
  "markup.heading" = {
    fg = bright_blue;
    modifiers = ["bold"];
  };
  "markup.list" = gray06;
  "markup.bold" = {modifiers = ["bold"];};
  "markup.italic" = {modifiers = ["italic"];};
  "markup.link.url" = {
    fg = green;
    modifiers = ["underlined"];
  };
  "markup.link.text" = {
    fg = blue;
    modifiers = ["italic"];
  };
  "markup.raw" = yellow;

  # --- Diff
  "diff.plus" = bright_green;
  "diff.minus" = red;
  "diff.delta" = bright_blue;

  # --- UI
  "ui.background" = {bg = bg;};
  "ui.background.separator" = {fg = fg;};

  "ui.linenr" = {fg = gray04;};
  "ui.linenr.selected" = {fg = fg;};

  "ui.statusline" = {
    fg = status_line_fg;
    bg = gray01;
  };
  "ui.statusline.inactive" = {
    fg = fg;
    bg = gray01;
    modifiers = ["dim"];
  };
  "ui.statusline.normal" = {
    fg = bg;
    bg = cyan;
    modifiers = ["bold"];
  };
  "ui.statusline.insert" = {
    fg = bg;
    bg = blue;
    modifiers = ["bold"];
  };
  "ui.statusline.select" = {
    fg = bg;
    bg = magenta;
    modifiers = ["bold"];
  };

  "ui.popup" = {bg = gray01;};
  "ui.window" = {fg = gray02;};
  "ui.help" = {
    bg = gray01;
    fg = white;
  };

  "ui.text" = {fg = fg;};
  "ui.text.focus" = {fg = fg;};

  "ui.virtual" = {fg = gray02;};
  "ui.virtual.ruler" = {bg = gray02;};
  "ui.virtual.indent-guide" = {fg = gray02;};
  "ui.virtual.inlay-hint" = {fg = gray03;};

  "ui.selection" = {
    bg = gray02;
    fg = bright_white;
  };
  "ui.selection.primary" = {
    bg = gray02;
    fg = bright_white;
  };

  # Cursor (explicit fg+bg so it never vanishes)
  "ui.cursor" = {
    fg = bg;
    bg = cursor;
  };
  "ui.cursor.primary" = {
    fg = bg;
    bg = cursor;
  };
  "ui.cursor.match" = {
    fg = yellow;
    modifiers = ["bold" "underlined"];
  };
  "ui.cursorline.primary" = {bg = gray01;};

  "ui.highlight" = {bg = gray02;};

  "ui.menu" = {
    fg = white;
    bg = gray01;
  };
  "ui.menu.selected" = {
    fg = bright_white;
    bg = gray03;
  };
  "ui.menu.scroll" = {
    fg = gray04;
    bg = gray01;
  };

  # --- Diagnostics / severities
  diagnostic = {modifiers = ["underlined"];};
  "diagnostic.unnecessary" = {modifiers = ["dim"];};
  "diagnostic.deprecated" = {modifiers = ["crossed_out"];};

  warning = yellow;
  error = red;
  info = bright_blue;
  hint = bright_cyan;
}
