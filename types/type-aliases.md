# Type Aliases

A __type alias__ is just a way to give a different name to a type. This may sound a bit silly: after all, types already have names! However, Pony can express some complicated types, and it can be convenient to have a short way to talk about them.

We'll give a couple examples of using type aliases, just to get the feel of them.

## Enumerations

One way to use type aliases is to express an enumeration. For example, imagine we want to say something must either be Red, Blue or Green. We could write something like this:

```pony
primitive Red
primitive Blue
primitive Green

type Colour is (Red | Blue | Green)
```

There are two new concepts in there. The first is the type alias, introduced with the keyword `type`. It just means that the name that comes after `type` will be translated by the compiler to the type that comes after `is`.

The second new concept is the type that comes after `is`. It's not a single type! Instead, it's a __union__ type. You can read the `|` symbol as __or__ in this context, so the type is "Red or Blue or Green".

A union type is a form of _closed world_ type. That is, it says every type that can possibly be a member of it. In contrast, object-oriented subtyping is usually _open world_, e.g. in Java, an interface can be implemented by any number of classes.

You can also declare constants like in C or Go like this,
```pony
primitive Red    fun apply(): U32 => 0xFF0000FF
primitive Green  fun apply(): U32 => 0x00FF00FF
primitive Blue   fun apply(): U32 => 0x0000FFFF

type Colour is (Red | Blue | Green)
```

or namespace them like this
```pony
primitive Colours
  fun red(): U32 => 0xFF0000FF
  fun green(): U32 => 0x00FF00FF
```

You might also want to iterate over the enum like this to print its name for debugging purposes
```pony
primitive ColourList
  fun tag apply(): Array[Colour] =>
    [Red; Green; Blue]

for colour in ColourList().values() do
end
```

## Complex types

If a type is complicated, it can be nice to give it a mnemonic name. For example, if we want to say that a type must implement more than one interface, we could say:

```pony
interface HasName
  fun name(): String

interface HasAge
  fun age(): U32

interface HasAddress
  fun address(): String

type Person is (HasName & HasAge & HasAddress)
```

This use of complex types applies to traits, not just interfaces:

```pony
trait HasName
  fun name(): String => "Bob"

trait HasAge
  fun age(): U32 => "42"

trait HasAddress
  fun address(): String => "3 Abbey Road"

type Person is (HasName & HasAge & HasAddress)
```

There's another new concept here: the type has a `&` in it. This is similar to the `|` of a __union__ type: it means this is an __intersection__ type. That is, it's something that must be _all_ of `HasName`, `HasAge` _and_ `HasAddress`.

But the use of `type` here is exactly the same as the enumeration example above, it's just providing a name for a type that is otherwise a bit tedious to type out over and over.

Another example, this time from the standard library, is `SetIs`. Here's the actual definition:

```pony
type SetIs[A] is HashSet[A, HashIs[A!]]
```

Again there's something new here. After the name `SetIs` comes the name `A` in square brackets. That's because `SetIs` is a __generic type__. That is, you can give a `SetIs` another type as a parameter, to make specific kinds of set. If you've used Java or C#, this will be pretty familiar. If you've used C++, the equivalent concept is templates, but they work quite differently.

And again the use of `type` just provides a more convenient way to refer to the type we're aliasing:

```pony
HashSet[A, HashIs[A!]]
```

That's another __generic type__. It means a `SetIs` is really a kind of `HashSet`. Another concept has snuck in, which is `!` types. This is a type that is the __alias__ of another type. That's tricky stuff that you only need when writing complex generic types, so we'll leave it for later.

One more example, again from the standard library, is the `Map` type that gets used a lot. It's actually a type alias. Here's the real definition of `Map`:

```pony
type Map[K: (Hashable box & Comparable[K] box), V] is HashMap[K, V, HashEq[K]]
```

Unlike our previous example, the first type parameter, `K`, has a type associated with it. This is a __constraint__, which means when you parameterise a `Map`, the type you pass for `K` must be a subtype of the constraint.

Also, notice that `box` appears in the type. This is a __reference capability__. It means there is a certain class of operations we need to be able to do with a `K`. We'll cover this in more detail later.

Just like our other examples, all this really means is that `Map` is really a kind of `HashMap`.

## Other stuff

Type aliases get used for a lot of things, but this gives you the general idea. Just remember that a type alias is always a convenience: you could replace every use of the type alias with the full type after the `is`.

In fact, that's exactly what the compiler does.
