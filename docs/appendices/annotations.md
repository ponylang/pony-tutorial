# Program Annotations

In Pony, we provide a special syntax for implementation-specific annotations to various elements of a program. The basic syntax is a comma-separated list of identifiers surrounded by backslashes:

```pony
--8<-- "appendices-annotations-syntax.pony"
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

Recognised on a `struct` declaration. Removes padding in the associated `struct`, making it ABI-compatible with a packed C structure with compatible members (declared with the `__attribute__((packed))` extension or the `#pragma pack` preprocessor directive in many C compilers).

```pony
--8<-- "appendices-annotations-packed-annotation.pony"
```

#### `likely` and `unlikely`

Recognised on a conditional expression (`if`, `while`, `until` and `|` (as a pattern matching case)). Gives optimisation hints to the compiler on the likelihood of a given conditional expression.

```pony
--8<-- "appendices-annotations-likely-and-unlikely-annotations.pony"
```

### `nodoc`

Recognised on objects and methods (`actor`, `class`, `struct`, `primitive`, `trait`, `interface`, `new`, `be`, `fun`). Indicates to the documentation system that the item and any of its children shouldn't be included in generated output.

```pony
--8<-- "appendices-annotations-nodoc-annotation.pony"
```

### `nosupertype`

Recognised on objects(`actor`, `class`, `primitive`, `struct`). A type annotated with `nosupertype` will not be a subtype of any other type (except _), even if the type structurally provides an interface. If a `nosupertype` type has a provides list, a compiler error is reported. As a result, a `nosupertype` type is excluded from both nominal and structural subtyping.

Here's an example of how `nosupertype` can be important:

```pony
--8<-- "appendices-annotations-empty-without-nosupertype-annotation.pony"
```

The above code won't compile because you could supply `Empty ref`. Doing so results in a compiler error about an unsafe match because we would need to distinguish between `Empty val` and `Empty ref` at runtime.

By adding `nosupertype` to the definition of `Empty`, we declare that `Empty` is not a subtype of `Any` and thereby allow the code to compile as there is no longer an unsafe match.

```pony
--8<-- "appendices-annotations-empty-with-nosupertype-annotation.pony"
```

`nosupertype` is particularly valuable when constructing generic classes like collections that need a marker class to describe "lack of an item".
