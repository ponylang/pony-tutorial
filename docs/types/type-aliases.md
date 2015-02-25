A __type alias__ is just a way to give a different name to a type. This may sound a bit silly: after all, types already have names! However, Pony can express some complicated types, and it can be convenient to have a short way to talk about them.

We'll give a couple examples of using type aliases, just to get the feel of them.

# Enumerations

One way to use type aliases is to express an enumeration. For example, imagine we want to say something must either be Red, Blue or Green. We could write something like this:

```
primitive Red
primitive Blue
primitive Green

type Colour is (Red | Blue | Green)
```

There are two new concepts in there. The first is the type alias, introduced with the keyword `type`. It just means that the name that comes after `type` will be translated by the compiler to the type that comes after `is`.

The second new concept is the type that comes after `is`. It's not a single type! Instead, it's a __union__ type. You can read the `|` symbol as __or__ in this context, so the type is "Red or Blue or Green".

A union type is a form of _closed world_ type. That is, it says every type that can possibly be a member of it. In contrast, object-oriented subtyping is usually _open world_, e.g. in Java, an interface can be implemented by any number of classes.

# Complex types

If a type is complicated, it can be nice to give it a mnemonic name. For example, in the standard library, there is a `Map` type that gets used a lot. It's actually a type alias. Here's the real definition of `Map`:

```
type Map[K: (Hashable box & Comparable[K] box), V] is HashMap[K, V, HashEq[K]]
```

That line has a ton of new concepts in it. We'll mention them briefly, and cover them in detail later.

The first is that after the name `Map` comes some stuff in square brackets. That's because `Map` is a __generic type__. That is, you can give a `Map` some other types as parameters, to make specific kinds of `Map`. If you've used Java or C#, this will be pretty familiar. If you've used C++, the equivalent concept is templates, but they work quite differently.

Next is that the first type parameter, `K`, has a type associated with it. This is a __constraint__, which means when you parameterise a `Map`, they type you pass for `K` must be a subtype of the constraint.

Next is that the constraint type is has a `&` in it. This is similar to the `|` of a __union__ type: it means this is an __intersection__ type. That is, it's something that must be _both_ a `Hashable box` _and_ a `Comparable[K] box`.

Next is that `box` appears in the type. This is a __capability__. It means there is a certain class of operations we need to be able to do on a `K`. We'll cover this in more detail later.

Finally, there's what we're aliasing:

```
HashMap[K, V, HashEq[K]]
```

That's another __generic type__. It means a `Map` is really a kind of `HashMap`.

# Other stuff

Type aliases get used for a lot of things, but this gives you the general idea. Just remember that a type alias is always a convenience: you could replace every use of the type alias with the full type after the `is`.

In fact, that's exactly what the compiler does.
