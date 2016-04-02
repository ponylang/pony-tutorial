# Type Expressions

The types we've talked about so far can also be combined in 
__type expressions__. If you're used to object-oriented programming, you may 
not have seen these before, but they are common in functional programming. A 
__type expression__ is also called an __algebraic data type__.

There are three kinds of type expression: __tuples__, __unions__, and 
__intersections__.

## Tuples

A __tuple__ is a sequence of types. For example, if we wanted something that 
was a `String` followed by a `U64`, we would write this:

```pony
var x: (String, U64)
x = ("hi", 3)
x = ("bye", 7)
```

All type expressions are written in parentheses, and the elements of a tuple 
are separated by a comma. We can also destructure a tuple using assignment:

```pony
(var y, var z) = x
```

Or we can access the elements of a tuple directly:

```pony
var y = x._1
var z = x._2
```

Note that there's no way to assign to an element of a tuple. Instead, you can 
just reassign the entire tuple, like this:

```pony
x = ("wombat", x._2)
```

__Why use a tuple instead of a class?__ Tuples are a way to express a 
collection of values that doesn't have any associated code or expected 
behaviour. Basically, if you just need a quick collection of things, maybe to 
return more than one value from a function for example, you can use a tuple.

## Unions

A __union__ type is written like a __tuple__, but it uses a `|` (pronounced 
"or" when reading the type) instead of a `,` between its elements. Where a 
tuple represents a collection of values, a union represents a _single_ value 
that can be any of the specified types.

Unions can be used for tons of stuff that require multiple concepts in other 
languages. For example, optional values, enumerations, marker values, and more.

```pony
var x: (String | None)
```

Here we have an example of using a union to express an optional type, where `x` 
might be a `String`, but it also might be `None`.

## Intersections

An __intersection__ uses a `&` (pronounced "and" when reading the type) between 
its elements. It represents the exact opposite of a union: it is a _single_ 
value that is _all_ of the specified types, at the same time!

This can be very useful for combining traits or interfaces, for example. Here's 
something from the standard library:

```pony
type Map[K: (Hashable box & Comparable[K] box), V] is HashMap[K, V, HashEq[K]]
```

That's a fairly complex type alias, but let's look at the constraint of `K`. 
It's `(Hashable box & Comparable[K] box)`, which means `K` is `Hashable` _and_ 
it is `Comparable[K]`, at the same time.

## Combining type expressions

Type expressions can be combined into more complex types. Here's another 
example from the standard library:

```pony
var _array: Array[((K, V) | _MapEmpty | _MapDeleted)]
```

Here we have an array where each element is either a tuple of `(K, V)` or a 
`_MapEmpty` or a `_MapDeleted`.

Because every type expression has parentheses around it, they are actually easy 
to read once you get the hang of it. However, if you use a complex type 
expression often, it can be nice to provide a type alias for it.

```pony
type Number is (Signed | Unsigned | Float)

type Signed is (I8 | I16 | I32 | I64 | I128)

type Unsigned is (U8 | U16 | U32 | U64 | U128)

type Float is (F32 | F64)
```

Those are all type aliases used by the standard library.

__Is `Number` a type alias for a type expression that contains other type 
aliases?__ Yes! Fun, and convenient.
