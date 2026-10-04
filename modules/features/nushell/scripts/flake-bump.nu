# Update flake inputs and print a summary; commit later with `flake-bump commit`.
export def main [
  ...inputs: string # inputs to update, all if none given
] {
  cd (git rev-parse --show-toplevel)
  nix flake update ...$inputs
  print (lock-message | default "flake.lock unchanged")
}

# Commit flake.lock with a summary of what changed since HEAD.
export def commit [] {
  cd (git rev-parse --show-toplevel)
  let msg = lock-message
  if $msg == null {
    print "flake.lock unchanged"
    return
  }
  git commit --quiet --message $msg -- flake.lock
  git log --oneline -1
}

def lock-message [] {
  message (git show HEAD:flake.lock | from json) (open --raw flake.lock | from json)
}

# Every input reachable from root as {path, node}, e.g. `flake-parts/nixpkgs-lib`.
# `follows` inputs are lists and point at nodes listed elsewhere, so skip them.
def walk [lock: record, key: string, prefix: string = ""] {
  ($lock.nodes | get $key).inputs? | default {} | transpose name ref
  | where ($it.ref | describe) == "string"
  | each {|i|
    let path = if $prefix == "" { $i.name } else { $"($prefix)/($i.name)" }
    [{path: $path node: ($lock.nodes | get $i.ref)}] ++ (walk $lock $i.ref $path)
  }
  | flatten
}

def rev [node] {
  $node.locked.rev? | default ($node.locked.narHash | str substring 7..) | str substring 0..<7
}

def day [node] {
  $node.locked.lastModified * 1_000_000_000 | into datetime | format date "%Y-%m-%d"
}

def message [old: record, new: record] {
  let changes = walk $new $new.root | rename path new
  | join --outer (walk $old $old.root | rename path old) path
  | where {|c| $c.old?.locked?.narHash? != $c.new?.locked?.narHash? }
  | sort-by path
  if ($changes | is-empty) { return null }

  let top = $changes | where not ($it.path | str contains "/") | get path
  let subject = if ($top | is-empty) or ($top | length) > 3 {
    "chore: bump flake inputs"
  } else {
    $"chore: bump ($top | str join ', ')"
  }

  let width = $changes | get path | str length | math max
  let body = $changes | each {|c|
    let change = if $c.old? == null {
      $"added (rev $c.new)  (day $c.new)"
    } else if $c.new? == null {
      "removed"
    } else {
      $"(rev $c.old) → (rev $c.new)  (day $c.old) → (day $c.new)"
    }
    $"($c.path | fill -w $width)  ($change)"
  }

  [$subject "" ...$body] | str join "\n"
}
