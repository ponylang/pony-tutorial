---
title: "Traits and Interfaces"
section: "Types"
menu:
  toc:
    parent: "types"
    weight: 50
---

Like other object-oriented languages, Pony has __subtyping__. That is, some types serve as _categories_ that other types can be members of.

There are two kinds of __subtyping__ in programming languages: __nominal__ and __structural__. They're subtly different, and most programming languages only have one or the other. Pony has both!

## Nominal subtyping

This kind of subtyping is called __nominal__ because it is all about __names__.

If you've done object-oriented programming before, you may have seen a lot of discussion about _single inheritance_, _multiple inheritance_, _mixins_, _traits_, and similar concepts. These are all examples of __nominal subtyping__.

The core idea is that you have a type that declares it has a relationship to some category type. In Java, for example, a __class__ (a concrete type) can __implement__ an __interface__ (a category type). In Java, this means the class is now in the category that the interface represents. The compiler will check that the class actually provides everything it needs to.

## Traits: nominal subtyping

Pony has nominal subtyping, using __traits__. A __trait__ looks a bit like a __class__, but it uses the keyword `trait` and it can't have any fields.

```pony
trait Named
  fun name(): String => "Bob"

class Bob is Named
```

Here, we have a trait `Named` that has a single function `name` that returns a String. It also provides a default implementation of `name` that returns the string literal "Bob".

We also have a class `Bob` that says it `is Named`. This means `Bob` is in the `Named` category. In Pony, we say _Bob provides Named_, or sometimes simply _Bob is Named_.

Since `Bob` doesn't have its own `name` function, it uses the one from the trait. If the trait's function didn't have a default implementation, the compiler would complain that `Bob` had no implementation of `name`.

```pony
trait Named
  fun name(): String => "Bob"
  
trait Bald
  fun hair(): Bool => false
 
 class Bob is (Named & Bald)
 ```
It is possible for a class to have relationships with multiple categories. In the above example, the class `Bob` _provides both Named and Bald_. 

```pony
trait Named
  fun name(): String => "Bob"
  
trait Bald is Named
  fun hair(): Bool => false
 
 class Bob is Bald
 ```
It is also possible to combine categories together. In the example above, all `Bald` classes are automatically `Named`. Consequently, the `Bob` class has access to both hair() and name() default implementation of their respective trait. One can think of the `Bald`category to be more specific than the `Named` one.


```pony
class Larry
  fun name(): String => "Larry"
```

Here, we have a class `Larry` that has a `name` function with the same signature. But `Larry` does __not__ provide `Named`!

__Wait, why not?__ Because `Larry` doesn't say it `is Named`. Remember, traits are __nominal__: a type that wants to provide a trait has to explicitly declare that it does. And `Larry` doesn't.

## Structural subtyping

There's another kind of subtyping, where the name doesn't matter. It's called __structural subtyping__, which means that it's all about how a type is built, and nothing to do with names.

A concrete type is a member of a structural category if it happens to have all the needed elements, no matter what it happens to be called.

If you've used Go, you'll recognise that Go interfaces are structural types.

## Interfaces: structural subtyping

Pony has structural subtyping too, using __interfaces__. Interfaces look like traits, but they use the keyword `interface`.

```pony
interface HasName
  fun name(): String
```

Here, `HasName` looks a lot like `Named`, except it's an interface instead of a trait. This means both `Bob` and `Larry` provide `HasName`! The programmers that wrote `Bob` and `Larry` don't even have to be aware that `HasName` exists.

Pony interfaces can have functions with default implementations as well. A type will only pick those up if it explicitly declares that it `is` that interface.

__Should I use traits or interfaces in my own code?__ Both! Interfaces are more flexible, so if you're not sure what you want, use an interface. But traits are a powerful tool as well: they stop _accidental subtyping_.
