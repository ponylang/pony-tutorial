# Type Expressions

The types we've talked about so far can also be combined in __type expressions__. If you're used to object-oriented programming, you may not have seen these before, but they are common in functional programming. A __type expression__ is also called an __algebraic data type__.

There are three kinds of type expression: __tuples__, __unions__, and __intersections__.

## Tuples

A __tuple__ type is a sequence of types. For example, if we wanted something that was a `String` followed by a `U64`, we would write this:

```pony
--8<-- "type-expressions-tuple-declaration.pony"
```

All type expressions are written in parentheses, and the elements of a tuple are separated by a comma. We can also destructure a tuple using assignment:

```pony
--8<-- "type-expressions-tuple-destructuring.pony"
```

Or we can access the elements of a tuple directly:

```pony
--8<-- "type-expressions-tuple-direct-access.pony"
```

Note that there's no way to assign to an element of a tuple. Instead, you can just reassign the entire tuple, like this:

```pony
--8<-- "type-expressions-tuple-reassignment.pony"
```

__Why use a tuple instead of a class?__ Tuples are a way to express a collection of values that doesn't have any associated code or expected behaviour. Basically, if you just need a quick collection of things, maybe to return more than one value from a function, for example, you can use a tuple.

## Unions

A __union__ type is written like a __tuple__, but it uses a `|` (pronounced "or" when reading the type) instead of a `,` between its elements. Where a tuple represents a collection of values, a union represents a _single_ value that can be any of the specified types.

Unions can be used for tons of stuff that require multiple concepts in other languages. For example, optional values, enumerations, marker values, and more.

```pony
--8<-- "type-expressions-union.pony"
```

Here we have an example of using a union to express an optional type, where `x` might be a `String`, but it also might be `None`.

## Intersections

An __intersection__ uses a `&` (pronounced "and" when reading the type) between its elements. It represents the exact opposite of a union: it is a _single_ value that is _all_ of the specified types, at the same time!

This can be very useful for combining traits or interfaces, for example. Here's something from the standard library:

```pony
--8<-- "type-expressions-intersection.pony"
```

That's a fairly complex type alias, but let's look at the constraint of `K`. It's `(Hashable box & Comparable[K] box)`, which means `K` is `Hashable` _and_ it is `Comparable[K]`, at the same time.

## Combining type expressions

Type expressions can be combined into more complex types. Here's another example from the standard library:

```pony
--8<-- "https://raw.githubusercontent.com/ponylang/ponyc/main/packages/collections/map.pony:22"
```

Here we have an array where each element is either a tuple of `(K, V)` or a `_MapEmpty` or a `_MapDeleted`.

Because every type expression has parentheses around it, they are actually easy to read once you get the hang of it. However, if you use a complex type expression often, it can be nice to provide a type alias for it.

```pony
--8<-- "type-expressions-type-alias.pony"
```

Those are all type aliases used by the standard library.

__Is `Number` a type alias for a type expression that contains other type aliases?__ Yes! Fun, and convenient.
