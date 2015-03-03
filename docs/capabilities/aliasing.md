__Aliasing__ means having more than one variable that points to the same object.

In most programming languages, aliasing is pretty simple. You just assign some variable to another variable, and there you go, you have an alias. The variable you assign to has the same type (or some supertype) as what's being assigned to it, and everything is fine.

In Pony, that works for some capabilities, but not all.

# Aliasing and deny guarantees

The reason for this is that `iso` capabilities deny other `iso` variables that point to the same object. That is, you can only have one `iso` variable pointing to any given object. The same goes for `trn`.

```
fun test(a: Wombat iso) =>
  var b: Wombat iso = a // Not allowed!
```

Here we have some function that gets passed an isolated Wombat. If we try to alias `a` by assigning it to `b`, we'll be breaking capability guarantees so the compiler will stop us.

__What can I alias an `iso` as?__ Since an `iso` says no other variable can be used by _any_ actor to read from or write to that object, we can only create aliases to an `iso` that can neither read nor write. Fortunately, we've got a capability that does exactly that: `tag`. So we can do this and the compiler will be happy:

```
fun test(a: Wombat iso) =>
  var b: Wombat tag = a // Allowed!
```

__What about aliasing `trn`?__ Since a `trn` says no other variable can be used by _any_ actor to write to that object, we need something that doesn't allow writing, but also doesn't prevent our `trn` variable from writing. Fortunately, weve got a capability that does that too: `box`. So we can do this and the compiler will be happy:

```
fun test(a: Wombat trn) =>
  var b: Wombat box = a // Allowed!
```

__What about aliasing other stuff?__ Everything else can be aliased as itself. So `ref` can be aliased as `ref`, `val` can be aliased as `val`, `box` can be aliased as `box` and `tag` can be aliased as `tag`.

# What counts as making an alias?

There are two things that count as making an alias:

1. When you __assign__ a value to a variable. This could be a local variable or a field.
2. When you __pass__ a value as an argument to a method.

In both cases, you are making a new _name_ for the object. This might be the name of a local variable, the name of a field, or the name of a parameter to a method.

# Consuming a variable

Sometimes, you want to _move_ an object from one variable to another. In other words, you don't want to make a _new_ name for the object, exactly, you want to move the object from some existing name to a different one.

You can do this by using consume. When you consume a variable you take the value out of it, effectively leaving the variable empty. No code can read from that variable again until a new value is written to it. Consuming a local variable or a parameter allows you to make an alias with the same type, even if it's an `iso` or `trn`. For example:

```
fun test(a: Wombat iso) =>
  var b: Wombat iso = consume a // Allowed!
```

The compiler is happy with that, because by consuming `a`, you've said the value can't be used again and the compiler will complain if you try to.

```
fun test(a: Wombat iso) =>
  var b: Wombat iso = consume a // Allowed!
  var c: Wombat tag = a // Not allowed!
```

Here's an example of that. When you try to assign `a` to `c`, the compiler will complain.

__Can I `consume` a field?__ Definitely not! Consuming something means it is empty, that is, it has no value. There's no way to be sure no other alias to the object will access that field. If we tried to access a field that was empty, we would crash. But there's a way to do what you want to do: _destructive read_.

# Destructive read

There's another way to _move_ a value from one name to another. Earlier, we talked about how assignment in Pony returns the _old_ value of the left-hand side, rather than the new value. This is called _destructive read_, and we can use it to do what we want to do, even with fields.

```
class Aardvark
  var buddy: Wombat iso

  fun test(a: Wombat iso) =>
    var b: Wombat iso = buddy = consume a // Allowed!
```

Here, we consume `a`, assign it to the field `buddy`, and assign the _old_ value of `buddy` to `b`.

__Why is it ok to destructively read fields when we can't consume them?__ Because when we do a destructive read, we assign to the field so it always has a value. So, unlike `consume`, there's no time when the field is empty, so it's safe and the compiler doesn't complain.

# Ephemeral types

In Pony, every expression has a type. So what's the type of `consume a`? It's not the same type as `a`, because it might not be possible to alias `a`. Instead, it's an __ephemeral__ type. That is, it's a type for a value that currently has no name (it might have a name through some other alias, but not the one we just consumed or destructively read).

To show a type is ephemeral, we put a `^` at the end. For example:

```
fun test(a: Wombat iso): Wombat iso^ =>
  consume a
```

Here, our function takes an isolated Wombat as a parameter, and returns an ephemeral isolated Wombat.

This is useful for dealing with `iso` and `trn` types, and for generic types, but it's also important for constructors. A constructor always returns an ephemeral type, because it's a new object.

# Alias types

For the same reason Pony has ephemeral types, it also has alias types. An alias type is a way of saying "whatever we can safely alias this thing as". It's only needed when dealing with generic types, which we'll discuss later.

We indicate an alias type by putting a `!` at the end. Here's an example:

```
fun test(a: A) =>
  var b: A! = a
```

Here, we're using `A` as a __type variable__, which we'll cover later. So `A!` means "an alias of whatever type `A` is".
