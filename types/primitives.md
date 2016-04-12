# Primitives

A __primitive__ is similar to a __class__, but there are two critical 
differences:

1. A __primitive__ has no fields.
2. There is only one instance of a user-defined __primitive__.

Having no fields means primitives are never mutable. Having a single instance 
means that if your code calls a constructor on a __primitive__ type, it always 
gets the same result back (except for built-in "machine word" primitives, 
covered below).

## What can you use a __primitive__ for?

There are three main uses of primitives (four, if you count built-in 
"machine word" primitives).

1. As a "marker value". For example, Pony often uses the __primitive__ `None` 
to indicate that something has "no value". Of course, it _does_ have a value, 
so that you can check what it is, and the value is the single instance of 
`None`.
2. As an "enumeration" type. By having a __union__ of __primitive__ types, 
you can have a type-safe enumeration. We'll cover __union__ types later.
3. As a "collection of functions". Since primitives can have functions, you can 
group functions together in a primitive type. You can see this in the standard 
library, where path handling functions are grouped in the __primitive__ `Path`, 
for example.

Primitives are quite powerful, particularly as enumerations. Unlike 
enumerations in other languages, each "value" in the enumeration is a complete 
type, which makes attaching data and functionality to enumeration values easy.

## Built-in primitive types

The __primitive__ keyword is also used to introduce certain built-in 
"machine word" types. Other than having a value associated with them, these 
work like user-defined primitives. These are:

* __Bool__. This is a 1-bit value that is either `true` or `false`.
* __ISize, ILong, I8, I16, I32, I64, I128__. Signed integers of various widths.
* __USize, ULong, U8, U16, U32, U64, U128__. Unsigned integers of various 
widths.
* __F32, F64__. Floating point numbers of various widths.

__ISize/USize__ correspond to the bitwidth of the native type `size_t`, which 
varies by platform. __ILong/ULong__ similarly correspond to the bitwidth of the 
native type `long`, which also varies by platform. The bitwidth of a native `int` 
is the same across all the platforms that Pony supports, and you can use 
__I32/U32__ for this.

## Primitive initialisation and finalisation

Primitives can have two special functions, `_init` and `_final`. `_init` is
called before any actor starts. `_final` is called after all actors have
terminated. The two functions take no parameter. The `_init` and `_final`
functions for different primitives always run sequentially.

A common use case for this is initialising and cleaning up C libraries without
risking untimely use by an actor.
