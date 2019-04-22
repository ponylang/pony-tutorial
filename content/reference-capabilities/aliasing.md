---
title: "Aliasing"
section: "Reference Capabilities"
menu:
  toc:
    parent: "reference-capabilities"
    weight: 60
toc: true
---

__Aliasing__ means having more than one reference to the same object, within the same actor. This can be the case for a variable or a field.

In most programming languages, aliasing is pretty simple. You just assign some variable to another variable, and there you go, you have an alias. The variable you assign to has the same type (or some supertype) as what's being assigned to it, and everything is fine.

In Pony, that works for some reference capabilities, but not all.

## Aliasing and deny guarantees

The reason for this is that the `iso` reference capability denies other `iso` variables that point to the same object. That is, you can only have one `iso` variable pointing to any given object. The same goes for `trn`.

```pony
fun test(a: Wombat iso) =>
  var b: Wombat iso = a // Not allowed!
```

Here we have some function that gets passed an isolated Wombat. If we try to alias `a` by assigning it to `b`, we'll be breaking reference capability guarantees so the compiler will stop us.

__What can I alias an `iso` as?__ Since an `iso` says no other variable can be used by _any_ actor to read from or write to that object, we can only create aliases to an `iso` that can neither read nor write. Fortunately, we've got a reference capability that does exactly that: `tag`. So we can do this and the compiler will be happy:

```pony
fun test(a: Wombat iso) =>
  var b: Wombat tag = a // Allowed!
```

__What about aliasing `trn`?__ Since a `trn` says no other variable can be used by _any_ actor to write to that object, we need something that doesn't allow writing but also doesn't prevent our `trn` variable from writing. Fortunately, we've got a reference capability that does that too: `box`. So we can do this and the compiler will be happy:

```pony
fun test(a: Wombat trn) =>
  var b: Wombat box = a // Allowed!
```

__What about aliasing other stuff?__ For both `iso` and `trn`, the guarantees require that aliases must give up on some ability (reading and writing for `iso`, writing for `trn`). For the other capabilities (`ref`, `val`, `box` and `tag`), aliases allow for the same operations, so such a reference can just be aliased as itself.

## What counts as making an alias?

There are three things that count as making an alias:

1. When you __assign__ a value to a variable or a field.
2. When you __pass__ a value as an argument to a method.
3. When you __call a method__, an alias of the receiver of the call is created. It is accessible as `this` within the method body.

In all three cases, you are making a new _name_ for the object. This might be the name of a local variable, the name of a field, or the name of a parameter to a method.

## Ephemeral types

In Pony, every expression has a type. So what's the type of `consume a`? It's not the same type as `a`, because it might not be possible to alias `a`. Instead, it's an __ephemeral__ type. That is, it's a type for a value that currently has no name (it might have a name through some other alias, but not the one we just consumed or destructively read).

To show a type is ephemeral, we put a `^` at the end. For example:

```pony
fun test(a: Wombat iso): Wombat iso^ =>
  consume a
```

Here, our function takes an isolated Wombat as a parameter and returns an ephemeral isolated Wombat.

This is useful for dealing with `iso` and `trn` types, and for generic types, but it's also important for constructors. A constructor always returns an ephemeral type, because it's a new object.

## Alias types

For the same reason Pony has ephemeral types, it also has alias types. An alias type is a way of saying "whatever we can safely alias this thing as". It's only needed when dealing with generic types, which we'll discuss later.

We indicate an alias type by putting a `!` at the end. Here's an example:

```pony
fun test(a: A) =>
  var b: A! = a
```

Here, we're using `A` as a __type variable__, which we'll cover later. So `A!` means "an alias of whatever type `A` is".
