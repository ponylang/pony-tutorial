---
title: "Overview"
section: "Generics"
layout: overview
menu:
  toc:
    identifier: "generics-overview"
    parent: "generics"
    weight: 1
---

Often when writing code you want to create similar classes or functions that differ only in the type that they operate on. The classic example of this is collection classes. You want to be able to create an `Array` that can hold objects of a particular type without creating an `IntArray`, `StringArray`, etc. This is where generics step in.

## Generic Classes

A generic class is a class that can have parameters, much like a method has parameters. The parameters for a generic class are types. Parameters are introduced to a class using square brackets.

Take the following example of a non-generic class:

```pony
class Foo
  var _c: U32

  new create(c: U32) =>
    _c = c

  fun get(): U32 => _c

  fun ref set(c: U32) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo(42)
    env.out.print(a.get().string())
    a.set(21)
    env.out.print(a.get().string())
```

This class only works for the type `U32`, a 32 bit unsigned integer. We can make this work over other types by making the type a parameter to the class. For this example it looks like:

```pony
class Foo[A: Any val]
  var _c: A

  new create(c: A) =>
    _c = c

  fun get(): A => _c

  fun ref set(c: A) => _c = c

actor Main
  new create(env:Env) =>
    let a = Foo[U32](42)
    env.out.print(a.get().string())
    a.set(21)

    env.out.print(a.get().string())
    let b = Foo[F32](1.5)
    env.out.print(b.get().string())

    let c = Foo[String]("Hello")
    env.out.print(c.get().string())
```

The first thing to note here is that the `Foo` class now takes a type parameter in square brackets, `[A: Any val]`. That syntax for the type parameter is:

Name: Constraint ReferenceCapability

In this case, the name is `A`, the constraint is `Any` and the reference capability is `val`. `Any` is used to mean that the type can be any type - it is not constrained. The remainder of the class definition replaces `U32` with the type name `A`.

The user of the class must provide a type when referencing the class name. This is done when creating it:

```pony
let a = Foo[U32](42)
let b = Foo[F32](1.5)
let c = Foo[String]("Hello")
```

That tells the compiler what specific class to create, replacing `A` with the type provided. For example, a `Foo[String]` usage becomes equivalent to:

```pony
class FooString
  var _c: String val

  new create(c: String val) =>
    _c = c

  fun get(): String val => _c

  fun ref set(c: String val) => _c = c
```

## Generic Methods

Methods can be generic too. They are defined in the same way as normal methods but have type parameters inside square brackets after the method name:

```pony
primitive Foo
  fun bar[A: Stringable val](a: A): String =>
    a.string()

actor Main
  new create(env:Env) =>
    let a = Foo.bar[U32](10)
    env.out.print(a.string())

    let b = Foo.bar[String]("Hello")
    env.out.print(b.string())
```

This example shows a constraint other than `Any`. The `Stringable` type is any type with a `string()` method to convert to a `String`.

These examples show the basic idea behind generics and how to use them. Real world usage gets quite a bit more complex and the following sections will dive deeper into how to use them.
