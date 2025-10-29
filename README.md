# nixos config

work in progress.

## misc

```nu
fd -t file -E *.lock -E *.kdl
| lines
| each {|f| $"// ($f)\n(cat $f)\n"}
| save structure.txt --force
```
