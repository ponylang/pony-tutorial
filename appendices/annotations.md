# Program Annotations

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

Annotations are entirely implementation-specific. In other words, the Pony compiler (or any other tool that processes Pony programs) is free to take any action for any annotation that it encounters, including not doing anything at all. The current list of annotations recognised by the Pony compiler is documented in the following section.

### Annotations in the Pony compiler

None for now.

Note that the Pony compiler will ignore annotations that it doesn't recognise, as well as the annotations described here if they're encountered in an unexpected place.
