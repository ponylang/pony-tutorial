---
title: "Program Annotations"
section: "Appendices"
menu:
  toc:
    parent: "appendices"
    weight: 100
toc: true
---

In Pony, we provide a special syntax for implementation-specific annotations to various elements of a program. The basic syntax is a comma-separated list of identifiers surrounded by backslashes:

```pony
\annotation1, annotation2\
```

Here, `annotation1` and `annotation2` can be any valid Pony identifier, i.e. a sequence of alphanumeric characters starting with a letter or an underscore.

## What can be annotated

Annotations are allowed after any scoping keyword or symbol. The full list is:

- `actor`
- `class`
- `struct`
- `primitive`
- `trait`
- `interface`
- `new`
- `fun`
- `be`
- `if` (only as a condition, not as a guard)
- `ifdef`
- `elseif`
- `else`
- `while`
- `repeat`
- `until`
- `for`
- `match`
- `|` (only as a case in a `match` expression)
- `recover`
- `object`
- `{` (only as a lambda)
- `with`
- `try`
- `then` (only when part of a `try` block)

## The effect of annotations

Annotations are entirely implementation-specific. In other words, the Pony compiler (or any other tool that processes Pony programs) is free to take any action for any annotation that it encounters, including not doing anything at all. Annotations starting with `ponyint` are reserved by the compiler for internal use and shouldn't be used by external tools.

### Annotations in the Pony compiler

The following annotations are recognised by the Pony compiler. Note that the Pony compiler will ignore annotations that it doesn't recognise, as well as the annotations described here if they're encountered in an unexpected place.

#### `packed`

Recognised on a a `struct` declaration. Removes padding in the associated `struct`, making it ABI-compatible with a packed C structure with compatible members (declared with the `__attribute__((packed))` extension or the `#pragma pack` preprocessor directive in many C compilers).

```pony
struct \packed\ MyPackedStruct
  var x: U8
  var y: U32
```

#### `likely` and `unlikely`

Recognised on a conditional expression (`if`, `while`, `until` and `|` (as a pattern matching case)). Gives optimisation hints to the compiler on the likelihood of a given conditional expression.

```pony
if \likely\ cond then
  foo
end

while \unlikely\ cond then
  bar
end

repeat
  baz
until \likely\ cond end

match obj
| \likely\ expr => foo
| \unlikely\ let capt: T => bar
end
```
