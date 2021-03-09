---
title: "Platform-dependent code"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 80
toc: true
---

The Pony libraries, of course, want to abstract platform differences. Sometimes you may want a `use` command that only works under certain circumstances, most commonly only on a particular OS or only for debug builds. You can do this by specifying a condition for a `use` command:

```pony
use "foo" if linux
use "bar" if (windows and debug)
```

Use conditions can use any of the methods defined in `builtin/Platform` as conditions.
There are currently the following booleans defined: `freebsd`, `linux`, `osx`, `posix` => `(freebsd or linux or osx)`, `windows`, `x86`, `arm`, `lp64`, `llp64`, `ilp32`, `native128`, `debug`

They can also use the operators `and`, `or`, `xor` and `not`. As with other expressions in Pony, parentheses __must__ be used to indicate precedence if more than one of `and`, `or` and `xor` is used.

Any use command whose condition evaluates to false is ignored.
