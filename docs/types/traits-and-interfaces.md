# Traits and Interfaces

Like other object-oriented languages, Pony has __subtyping__. That is, some types serve as _categories_ that other types can be members of.

There are two kinds of __subtyping__ in programming languages: __nominal__ and __structural__. They're subtly different, and most programming languages only have one or the other. Pony has both!

## Nominal subtyping

This kind of subtyping is called __nominal__ because it is all about __names__.

If you've done object-oriented programming before, you may have seen a lot of discussion about _single inheritance_, _multiple inheritance_, _mixins_, _traits_, and similar concepts. These are all examples of __nominal subtyping__.

The core idea is that you have a type that declares it has a relationship to some category type. In Java, for example, a __class__ (a concrete type) can __implement__ an __interface__ (a category type). In Java, this means the class is now in the category that the interface represents. The compiler will check that the class actually provides everything it needs to.

In Pony, nominal subtyping is done via the keyword `is`. `is` declares at the point of declaration that an object has a relationship to a category type. For example, to use nominal subtyping to declare that the class `Name` provides `Stringable`, you'd do:

```pony
class Name is Stringable
```

## Structural subtyping

There's another kind of subtyping, where the name doesn't matter. It's called __structural subtyping__, which means that it's all about how a type is built, and nothing to do with names.

A concrete type is a member of a structural category if it happens to have all the needed elements, no matter what it happens to be called.

Structural typing is very similar to [duck typing](https://en.wikipedia.org/wiki/Duck_typing) from dynamic programming languages, except that type compatibility is determined at compile time rather than at run time. If you've used Go, you'll recognise that Go interfaces are structural types.

You do not declare structural relationships ahead of time, instead it is done by checking if a given concrete type can fulfill the required interface. For example, in the code below, we have the interface `Stringable` from the standard library. Anything can be used as a `Stringable` so long as it provides the method `fun string(): String iso^`. In our example below, `ExecveError` provides the `Stringable` interface and can be used anywhere a `Stringable` is needed. Because `Stringable` is a structural type, `ExecveError` doesn't have to declare a relationship to `Stringable`, it simply has that relationship because it has "the same shape".

```pony
interface box Stringable
  """
  Things that can be turned into a String.
  """
  fun string(): String iso^
    """
    Generate a string representation of this object.
    """

primitive ExecveError
  fun string(): String iso^ => "ExecveError".clone()
```

## Nominal and structural subtyping in Pony

When discussing subtyping in Pony, it is common to say that `trait` is nominal subtyping and `interface` is structural subtyping, however, that isn't really true.

Both `trait` and `interface` can establish a relationship via nominal subtyping. Only `interface` can be used for structural subtyping.

### Nominal subtyping in Pony

The primary means of doing nominal subtyping in Pony is using __traits__. A __trait__ looks a bit like a __class__, but it uses the keyword `trait` and it can't have any fields.

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

It is also possible to combine categories together. In the example above, all `Bald` classes are automatically `Named`. Consequently, the `Bob` class has access to both hair() and name() default implementation of their respective trait. One can think of the `Bald` category to be more specific than the `Named` one.

```pony
class Larry
  fun name(): String => "Larry"
```

Here, we have a class `Larry` that has a `name` function with the same signature. But `Larry` does __not__ provide `Named`!

__Wait, why not?__ Because `Larry` doesn't say it `is Named`. Remember, traits are __nominal__: a type that wants to provide a trait has to explicitly declare that it does. And `Larry` doesn't.

You can also do nominal subtyping using the keyword `interface`. __Interfaces__ in Pony are primarily used for structural subtyping. Like traits, interfaces can also have default method implementations, but in order to use default method implementations, an interface must be used in a nominal fashion. For example:

```pony
interface HasName
  fun name(): String => "Bob"

class Bob is HasName

class Larry
  fun name(): String => "Larry"
```

Both `Bob` and `Larry` are in the category `HasName`. `Bob` because it has declared that it is a `HasName` and `Larry` because it is structurally a `HasName`.

### Structural subtyping in Pony

Pony has structural subtyping using __interfaces__. Interfaces look like traits, but they use the keyword `interface`.

```pony
interface HasName
  fun name(): String
```

Here, `HasName` looks a lot like `Named`, except it's an interface instead of a trait. This means both `Bob` and `Larry` provide `HasName`! The programmers that wrote `Bob` and `Larry` don't even have to be aware that `HasName` exists.

## Differences between traits and interfaces

It is common for new Pony users to ask, __Should I use traits or interfaces in my own code?__ Both! Interfaces are more flexible, so if you're not sure what you want, use an interface. But traits are a powerful tool as well.

### Private methods

A key difference between traits and interfaces is that interfaces can't have private methods. So, if you need private methods, you'll need to use a trait and have users opt in via nominal typing. Interfaces can't have private methods because otherwise, users could use them to break encapsulation and access private methods on concrete types from other packages. For example:

```pony
actor Main
  new create(env: Env) =>
    let x: String ref = "sailor".string()
    let y: Foo = x
    y._set(0, 'f')
    env.out.print("Hello, " + x)

interface Foo
  fun ref _set(i: USize, value: U8): U8
```

In the code above, the interface `Foo` allows access to the private `_set` method of `String` and allows for changing `sailor` to `failor` or it would anyway, if interfaces were allowed to have private methods.

### Open world enumerations

Traits allow you to create "open world enumerations" that others can participate in. For example:

```pony
trait Color

primitive Red is Color
primitive Blue is Color
```

Here we are using a trait to provide a category of things, `Color` that any things can opt into by declaring itself to be a `Color`. The creates an "open world" of enumerations that you can't do using the more traditional Pony approach using type unions.

```pony
primitive Red
primitive Blue

type Color is (Red | Blue)
```

In our trait based example, we can add new colors at any time. With the type union based approach, we can only add them by modifying definition of `Color` in the package that provides it.

Interfaces can't be used for open world enumerations. If we defined `Color` as an interface:

```pony
interface Color
```

Then literally everything in Pony would be a `Color` because everything matches the `Color` interface. You can however, do something similar using "marker methods" with an interface:

```pony
interface Color
  fun is_color(): None

primitive Red
  fun is_color(): None => None
```

Here we are using structural typing to create a collection of things that are in the category `Color` by providing a method that "marks" being a member of the category; `is_color`.

### Open world typing

We've covered a couple ways that traits can be better than interfaces, let's close with the reason for why we say, unless you have a reason to, you should use `interface` instead of `trait`. Interfaces are incredibly flexible. Because traits only provide nominal typing, a concrete type can only be in a category if it was declared as such by the programmer who wrote the concrete type. Interfaces allow you to create your own categorizations on the fly, as you need them, to group existing concrete types together however you need to.

Here's a contrived example:

```pony
interface Compactable
  fun ref compact()
  fun size()

class Compactor
  """
  Compacts data structures when their size crosses a threshold
  """
  let _threshold: USize

  new create(threshold: USize) =>
    _threshold = threshold

  fun ref try_compacting(thing: Compactable) =>
    if thing.size() > _threshold then
      thing.compact()
    end
```

The flexibility of interface has allowed us to define a type `Compactable` that we can use to allow our `Compactor` to accept a variety of data types including `Array`, `Map`, and `String` from the standard library.
