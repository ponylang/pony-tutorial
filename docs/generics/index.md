# Overview

Often when writing code you want to create similar classes or functions that differ only in the type that they operate on. The classic example of this is collection classes. You want to be able to create an `Array` that can hold objects of a particular type without creating an `IntArray`, `StringArray`, etc. This is where generics step in.

A generic class or method takes type parameters — types that the caller provides, much like a method takes value parameters. Pony uses square brackets for type parameters and parentheses for value parameters, so `Foo[U32]` creates a `Foo` whose type parameter is `U32`, and `Foo[U32](42)` also passes the value `42` to its constructor.

The following sections cover [how to use generics](using-generics.md) in Pony, how generics interact with [reference capabilities](generics-and-reference-capabilities.md), and how to [constrain](generic-constraints.md) what types a generic accepts.
